#!/usr/bin/env perl6

use Cro::HTTP::Server;
use Cro::HTTP::Router;
use Raku::Recipes::Roly;

my $rrr = Raku::Recipes::Roly.new();

my $recipes = route {
    get -> "Ingredient", Str $ingredient where $rrr.is-ingredient($ingredient) {
        content 'application/json', $rrr.calories-table{$ingredient};
    }
    get -> "Ingredient",
           Str $ingredient where !$rrr.is-ingredient($ingredient) {
        not-found;
    }
}

my Cro::Service $μservice = Cro::HTTP::Server.new(
        :host('localhost'), :port(31415), application => $recipes
);

$μservice.start;

react whenever signal(SIGINT) {
    $μservice.stop;
    exit;
}