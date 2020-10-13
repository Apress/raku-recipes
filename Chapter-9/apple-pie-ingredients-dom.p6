#!/usr/bin/env perl6

use WWW;
use DOM::Tiny;

my $URL = @*ARGS[0] // "https://en.wikibooks.org/wiki/Cookbook:Apple_Pie_I";
my $content = get($URL);

die "That $URL didn't work" unless $content;

my @all-lis = DOM::Tiny.parse( $content.split(/"<h2>"/)[1]).find('li').map: ~*;

my @my-lis = @all-lis.grep( /title..Cookbook ":"/)
        .map( { DOM::Tiny.parse( $_ ) } );

say @my-lis.map( "→ " ~ *.all-text).unique.join("\n");
