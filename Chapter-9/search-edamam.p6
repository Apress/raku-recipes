#!/usr/bin/env perl6

use Cro::HTTP::Client;
use URI::Encode;

my $appID = %*ENV{'EDAMAM_APP_ID'};
my $api-key = %*ENV{'EDAMAM_API_KEY'};
my $api-req = "\&app_id=$appID\&app_key=$api-key";
my $ingredient = @*ARGS[0] // "water";

my $cro = Cro::HTTP::Client.new(base-uri => "https://api.edamam.com/" );
my $response = await $cro.get( "search?q="
                                ~ uri_encode($ingredient) ~ $api-req);
my %data = await $response.body;

say %data<hits>.map( *<recipe><label> ).join: "\n";

