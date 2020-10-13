#!/usr/bin/env perl6

use Raku::Recipes::Grammar::RecipeMark;
use Raku::Recipes::Grammar::RecipeMark::Actions;

my $rm = Raku::Recipes::Grammar::RecipeMark.new;
my $action = Raku::Recipes::Grammar::RecipeMark::Actions.new;
for <main/rice/tuna-risotto
    main/rice/tuna-risotto-low-cost
    appetizers/carrot-wraps>
-> $fn {
    my $text = "recipes/$fn.md".IO.slurp;
    say $rm.parse( $text, actions => $action ).made;
}