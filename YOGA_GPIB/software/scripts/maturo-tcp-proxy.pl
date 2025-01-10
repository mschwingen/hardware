#!/usr/bin/perl
#
# Linux TCP->GPIB server
# (C) 2024 Michael Schwingen, <michael@schwingen.org>
# License: BSD 3-Clause

use strict;
use Getopt::Std;
use LinuxGpib;
use IO::Socket;
use IO::Select;
use Data::Dumper;
use IO::LCDproc;
 
my $device = "maturo";
my $tcpaddr = "0.0.0.0";
my $tcpport = 5021;
my $command;
my $result;
my $gpib_status;

sub usage() {
print STDERR << "EOF";
usage: $0 [-h help] [-d gpib_device] [-a tcp-address] [-p tcp-port]
EOF
}

#----------------------
getopts( "hd:a:p:", \my %opt ) or usage() and exit;
usage() and exit if $opt{h};

if ($opt{d}) {
    $device = $opt{d};
}

if ($opt{p}) {
    $tcpport = $opt{p};
}

if ($opt{a}) {
    $tcpaddr = $opt{a};
}


my $lcd_client  = IO::LCDproc::Client->new(name => "MATURO");
my $lcd_screen      = IO::LCDproc::Screen->new(name => "screen", heartbeat=>"off");

my $lcd_title       = IO::LCDproc::Widget->new(name => "maturo", align => "left", type => "title" );
my $lcd_line1       = IO::LCDproc::Widget->new(name => "lcd_line1", align => "left", xPos => 1, yPos => 2, type => "string"  );
$lcd_client->add( $lcd_screen );
$lcd_screen->add( $lcd_title, $lcd_line1);
$lcd_client->connect() or die "cannot connect: $!";
$lcd_client->initialize();

$lcd_title->set( data => "MATURO" );

open(my $LED_TRIGGER, '>/sys/class/leds/hat_led/shot') or die $!;
$LED_TRIGGER->autoflush;
    
# initialize GPIB device, device name is from /usr/local/etc/gpib.conf
my $dev = LinuxGpib::ibfind($device);
die "Can't open device $device!\n" unless $dev >= 0;

#----------
# Send command
print $LED_TRIGGER "\n";
$command = "*IDN?";
LinuxGpib::ibwrt($dev,$command,length($command));
LinuxGpib::ibrd($dev,$result,1000);
chomp($result);
my $device_idn = $result;
print "[Device $device: $device_idn]\n";

if ($device_idn ne "") {
    $lcd_line1->set( data => $device_idn );
} else {
    $lcd_line1->set( data => "no response" );
}
$lcd_client->flushAnswers();


my $main_socket;

$main_socket = IO::Socket::INET->new(
    Proto     => 'tcp',
    LocalAddr => $tcpaddr,
    LocalPort => $tcpport,
    Listen    => SOMAXCONN,
    Reuse     => 1) || die "can't setup socket";
$SIG{INT} = sub { $main_socket->close(); exit 0; };

print "[Server accepting clients at $tcpaddr:$tcpport for GPIB device $device]\n";

my $readable_handles = new IO::Select();
$readable_handles->add($main_socket);

my $SEPARATOR = "\n";

$/ = $SEPARATOR;

my $device = 0;

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
                my $expect_result = 0;
#		print Dumper($command) . "\n";
		chomp($command);
		print "$command\n";
                if ($command =~ /^CP/ ||
                    $command =~ /IDN/ ||
                    $command =~ "^P"  ||
                    $command =~ "^BU") {
                    $expect_result = 1;
                }
                if ($command =~ /LD 0 DV/i) {
                    $device = 0;
                }
                if ($command =~ /LD 1 DV/i) {
                    $device = 1;
                }
		$lcd_line1->set( data => $command );
		$lcd_client->flushAnswers();
		
		LinuxGpib::ibwrt($dev,$command,length($command));
		$result="";
		LinuxGpib::ibrd($dev,$result,1000);
		chomp($result);
		$result =~ s@^\s+@@; # strip leading whitespace

		$lcd_line1->set( data => $result );
		$lcd_client->flushAnswers();
		
		if ($command eq "CP" && $device == 0) {
		    $result = "100";
		    print "fake height response:\n";
                }
		if ($result ne "" && $expect_result) {
		    print $sock "$result" . $SEPARATOR;
		    print "$result\n";
                }
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


