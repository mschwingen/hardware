#!/usr/bin/perl
use IO::LCDproc;

my $client      = IO::LCDproc::Client->new(name => "IPSTATUS");
my $screen      = IO::LCDproc::Screen->new(name => "screen", heartbeat=>"off");

my $title 	= IO::LCDproc::Widget->new(name => "ipstatus", align => "left", type => "title" );
my $first       = IO::LCDproc::Widget->new(name => "first", align => "left", xPos => 1, yPos => 2, type => "string"  );
$client->add( $screen );
$screen->add( $title, $first);
$client->connect() or die "cannot connect: $!";
$client->initialize();

$title->set( data => "IP" );

while(1) {
    my $address = `hostname -I`;
    chomp($address);
#    print "<$address>\n";

    $first->set( data => $address );
    $client->flushAnswers();
    sleep 15;
}
