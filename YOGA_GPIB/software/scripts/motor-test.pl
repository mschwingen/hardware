#!/usr/bin/perl
#
# Linux TCP->GPIB server
# (C) 2024 Michael Schwingen, <michael@schwingen.org>
# License: BSD 3-Clause

use strict;
use Getopt::Std;
use IO::Socket;
use IO::Select;
use Data::Dumper;
use Device::I2C;
use Fcntl;

my $i2caddr = 0x2A;
my $tcpaddr = "0.0.0.0";
my $tcpport = 5022;
my $i2cdev = "/dev/i2c-1";

my $motordriver;

sub usage() {
print STDERR << "EOF";
usage: $0 [-h help] [-a tcp-address] [-p tcp-port] [-I i2c-device] [-i i2c-addr]
EOF
}

#----------------------
getopts( "ha:p:I:i:", \my %opt ) or usage() and exit;
usage() and exit if $opt{h};
if ($opt{a}) {
    $tcpaddr = $opt{a};
}
if ($opt{p}) {
    $tcpport = $opt{p};
}
if ($opt{i}) {
    $i2caddr = $opt{p};
}
if ($opt{I}) {
    $i2cdev = $opt{p};
}


$motordriver = Device::I2C->new($i2cdev, O_RDWR);
$motordriver->checkDevice(2*$i2caddr);

#print $motordriver->readByteData(0x00) . "\n";
#print chr($motordriver->readByteData(0xFD)) . "\n";
#print chr($motordriver->readByteData(0xFE)) . "\n";
#print chr($motordriver->readByteData(0xFF)) . "\n";
#print $motordriver->readByteData(0xFC) . "\n";

my $device_idn;
my $init_ok = 0;


print $device_idn . "\n";

sub set_position{
    my $pos = $_[0];
    my $wait = $_[1];
    my $result;
    print "set new position: <$pos>\n";
    $motordriver->writeByteData(0x00, $pos);
    if ($wait) {
        sleep(1);
        do {
            $result = $motordriver->readByteData(0x01);
            print "wait: <$result>\n";
#            sleep(1);
        } while ($result != 0);
    }
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
        $device_idn = "";
        $init_ok = 0;
        return;
    }

    my $pol;
    $pol = $motordriver->readByteData(0x00);
    print "init: current pos <$pol>\n"; 
    if ($pol != 0 && $pol != 90) {
        set_position($pol < 45 ? 90 : 0, 1);
    }
    $pol = $motordriver->readByteData(0x00);
    print "init: current pos <$pol>\n"; 
    if ($pol == 0 || $pol == 90) {
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

my $device = 0;

while (1) {
    my $new_readable;
    my $sock;
    # select() blocks until a socket is ready to be read or written
    ($new_readable) = IO::Select->select($readable_handles,undef, undef, 0);
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
		    $result = $motordriver->readByteData(0x00);
                } elsif ($command eq "PH") {
		    set_position(0, 0);
		    $result = "OK";
                } elsif ($command eq "PV") {
		    set_position(90, 0);
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


