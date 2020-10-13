#!/usr/bin/env perl6

use Raku::Recipes::Grammar::RecipeMark;

my $rm = Raku::Recipes::Grammar::RecipeMark.new;

for <tuna-risotto tuna-risotto-low-cost> -> $fn {
    my $text = "recipes/main/rice/$fn.md".IO.slurp;
    say $rm.parse( $text );
}