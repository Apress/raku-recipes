#!/usr/bin/env raku

use Raku::Recipes;
use JSON::Fast;

my %conf = from-json( slurp(@*ARGS[0] // "config.json" ) );
%calories-table = calories-table( %conf<dir> );
@products = %calories-table.keys;

my $max-calories = %conf<calories>;

my @results = gather for ^%conf<repetitions> {
    @products = @products.pick(*);
    my @ingredients = optimal-ingredients( @products.end , $max-calories );
    my $proteins = proteins( @ingredients );
    say @ingredients, " with $proteins g protein";
    take @ingredients => $proteins;
}
say "Best ", @results.Hash.maxpairs;


