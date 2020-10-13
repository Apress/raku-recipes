#!/usr/bin/env raku

use Raku::Recipes;
use Config::INI;

my %conf = Config::INI::parse_file( @*ARGS[0].IO.e ?? @*ARGS[0] !! "config.ini" );
say %conf;
%calories-table = calories-table( %conf<meta><dir> );
@products = %calories-table.keys;

my $max-calories = %conf<food><calories>;

my @results = gather for ^%conf<algorithm><repetitions> {
    @products = @products.pick(*);
    my @ingredients = optimal-ingredients( @products.elems -1 , $max-calories );
    my $proteins = proteins( @ingredients );
    say @ingredients, " with $proteins g protein";
    take @ingredients => $proteins;
}
say "Best ", @results.Hash.maxpairs;


