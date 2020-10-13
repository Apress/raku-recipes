#!/usr/bin/env perl6

use Cro::HTTP::Server;
use Cro::HTTP::Router;
use My::Routes;

my $recipes = route {
    include "pantry"   => keep-routes;
}

if ( $*PROGRAM eq $?FILE ) {
    my Cro::Service $μservice = Cro::HTTP::Server.new(
            :host('localhost'), :port(31415), application => $recipes
            );

    say "Starting service";
    $μservice.start;

    react whenever signal(SIGINT) {
        $μservice.stop;
        exit;
    }
}