#!/usr/bin/env perl6

use HTTP::UserAgent;


my $URL = @*ARGS[0] // "https://en.wikibooks.org/wiki/Cookbook:Apple_Pie_I";
my $recipr = HTTP::UserAgent.new;
my $response = $recipr.get($URL);

die $response.status-line unless $response.is-success;

my $ingredients = ( $response.content.split(/"<h2>"/))[1];

my @ingredients = ($ingredients ~~ m:g/"\/Cookbook:"(\w+)/);

say @ingredients.map( ~*[0] ).unique;

