#!/usr/bin/env perl

use v5.14;

use Markdent::Handler::CaptureEvents;
use Markdent::Parser;

my $handler = Markdent::Handler::CaptureEvents->new();
 
my $parser = Markdent::Parser->new(
    dialect => "GitHub",
    handler => $handler
);

$parser->parse( markdown => '# Here we go' );
my %events_hash = %{$handler->captured_events};

say join( @{$events_hash{'_events'}}, " " );
