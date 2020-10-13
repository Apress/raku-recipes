#!/usr/bin/env perl6

use GeoIP2;

my $ip = qx{curl -s ifconfig.me};
my $geo = GeoIP2.new( path => 'Chapter-9/GeoLite2-Country.mmdb' );
my $location = $geo.locate( ip => $ip );

say "The IP is in $location<country><names><en>, $location<continent><names><en>";