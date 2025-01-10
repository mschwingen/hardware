#!/usr/bin/perl
#
# Linux TCP->Motor Controller Interface
# (C) 2024 Michael Schwingen, <michael@schwingen.org>
# License: BSD 3-Clause

use strict;
use Getopt::Std;
use IO::Socket;
use IO::Select;
use Data::Dumper;
use IO::LCDproc;
use Device::I2C;
use Fcntl;

my $i2caddr = 0x2A;
my $tcpaddr = "0.0.0.0";
my $tcpport = 5022;
my $i2cdev = "/dev/i2c-1";
my $motordriver;
my $target_position = 0;

sub usage() {
print STDERR << "EOF";
usage: $0 [-h help] [-a tcp-address] [-p tcp-port] [-I i2c-device] [-i i2c-addr]
EOF
}

#----------------------
getopts( "ha:p:i:I:", \my %opt ) or usage() and exit;
usage() and exit if $opt{h};
if ($opt{a}) {
    $tcpaddr = $opt{a};
}
if ($opt{p}) {
    $tcpport = $opt{p};
}
if ($opt{i}) {
    $i2caddr = $opt{i};
}
if ($opt{I}) {
    $i2cdev = $opt{I};
}

my $lcd_client  = IO::LCDproc::Client->new(name => "Antenna");
my $lcd_screen      = IO::LCDproc::Screen->new(name => "screen", heartbeat=>"off");

my $lcd_title       = IO::LCDproc::Widget->new(name => "antenna", align => "left", type => "title" );
my $lcd_line1       = IO::LCDproc::Widget->new(name => "lcd_line1", align => "left", xPos => 1, yPos => 2, type => "string"  );
$lcd_client->add( $lcd_screen );
$lcd_screen->add( $lcd_title, $lcd_line1);
$lcd_client->connect() or die "cannot connect: $!";
$lcd_client->initialize();

$lcd_title->set( data => "Antenna" );

$motordriver = Device::I2C->new($i2cdev, O_RDWR);
$motordriver->checkDevice(2*$i2caddr);

#print $motordriver->readByteData(0x00) . "\n";
#print chr($motordriver->readByteData(0xFD)) . "\n";
#print chr($motordriver->readByteData(0xFE)) . "\n";
#print chr($motordriver->readByteData(0xFF)) . "\n";
#print $motordriver->readByteData(0xFC) . "\n";

my $device_idn;
my $init_ok = 0;

open(my $LED_TRIGGER, '>/sys/class/leds/hat_led/shot') or die $!;
$LED_TRIGGER->autoflush;

print $device_idn . "\n";

sub set_position{
    my $pos = $_[0];
    my $wait = $_[1];
    my $result;
    
    print $LED_TRIGGER "\n";
    
    my $current_pos = get_position();
    print "set new position: <$pos>, current position is <$current_pos>\n";
    if ($current_pos != 0 && $current_pos != 90) {
        $motordriver->writeByteData(0x00, 45);
        sleep(1);
    }
    $motordriver->writeByteData(0x00, $pos);
    if ($wait) {
        sleep(1);
        do {
            $result = $motordriver->readByteData(0x01);
            print "wait: <$result>\n";
            sleep(1);
        } while ($result != 0);
    }
}

sub get_position{
    my $result;
    print $LED_TRIGGER "\n";
    $result = $motordriver->readByteData(0x00);
    $lcd_line1->set( data => $result . chr(0x20) );
    $lcd_client->flushAnswers();
    return $result;
}

sub do_init{
    # check I2C motor driver
    my $id = chr($motordriver->readByteData(0xFD)) . 
        chr($motordriver->readByteData(0xFE)) . 
        chr($motordriver->readByteData(0xFF));

    if ($id eq "LCS") {
        $device_idn = "LCS Motor driver V";
        $device_idn .= $motordriver->readByteData(0xFC);
        $init_ok = 1;
    } else {
        print "Motor driver board not found, response was <$id>\n";
        $lcd_line1->set( data => "no response" );
        $lcd_client->flushAnswers();
        $device_idn = "";
        $init_ok = 0;
        return;
    }

    my $pos;
    $pos = get_position();
    print "init: current pos <$pos>\n"; 
    if ($pos != 0 && $pos != 90) {
        set_position(90, 1);
        set_position(0, 1);
    }
    $pos = get_position();
    print "init: current pos <$pos>\n"; 
    if ($pos == 0 || $pos == 90) {
        return "OK";
    }
    return "INIT ERROR";
}

do_init();
#die "hardware error" unless $init_ok;

my $main_socket;

$main_socket = IO::Socket::INET->new(
    Proto     => 'tcp',
    LocalAddr => $tcpaddr,
    LocalPort => $tcpport,
    Listen    => SOMAXCONN,
    Reuse     => 1) || die "can't setup socket";
$SIG{INT} = sub { $main_socket->close(); exit 0; };

print "[Server accepting clients at $tcpaddr:$tcpport]\n";

my $readable_handles = new IO::Select();
$readable_handles->add($main_socket);

my $SEPARATOR = "\n";

$/ = $SEPARATOR;

#my $device = 0;

while (1) {
    my $new_readable;
    my $sock;
    # select() blocks until a socket is ready to be read or written
    ($new_readable) = IO::Select->select($readable_handles,undef, undef, 60);
    # If it comes here, there is at least one handle to read from or
    # write to. For the moment, worry only about the read side.
    foreach $sock (@$new_readable) {
        if ($sock == $main_socket) {
            my $new_sock = $sock->accept();
	    printf "[Connect from %s]\n", $new_sock->peerhost;
            # Add it to the list, and go back to select because the 
            # new socket may not be readable yet.
            $readable_handles->add($new_sock);
	    $new_sock->autoflush(1);
	    $new_sock->timeout(1);
#	    print $new_sock "Welcome to $device_idn\n";
        } else {
            # It is an ordinary client socket, ready for reading.
            my $command = <$sock>;
            if ($command) {
                print $LED_TRIGGER "\n";
		my $result;
		chomp($command);
		$command =~ s/\R//g;
		#print Dumper($command) . "\n";
		print "<$command>\n";
                if ($command eq "*IDN?") {
		    $result = $device_idn;
                } elsif ($command eq "INIT") {
                    $result = do_init();
                } elsif ($command eq "P?") {
		    $result = get_position();
                } elsif ($command eq "PH") {
		    $target_position = 0;
		    set_position($target_position, 0);
		    $result = "OK";
                } elsif ($command eq "PV") {
		    $target_position = 90;
		    set_position($target_position, 0);
		    $result = "OK";
                } elsif ($command eq "INVALID") {
		    $target_position = 45;
		    set_position($target_position, 0);
		    $result = "OK";
                } elsif ($command eq "GO") {
                    $result = "OK";
                } elsif ($command eq "BU") {
		    $result = $motordriver->readByteData(0x01);
                } else {
		    $result = "ERROR";
		}
		$result = "HWERROR" unless ($init_ok);
		print $sock "$result" . $SEPARATOR;
		print "$result\n";
            } else {
                # Client closed socket. We do the same here, and remove
                # it from the readable_handles list
                $readable_handles->remove($sock);
		printf "[Disconnect from %s]\n", $sock->peerhost;
                close($sock);
            }
        }
    }   
}
