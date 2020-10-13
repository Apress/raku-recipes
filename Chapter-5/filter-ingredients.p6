#!/usr/bin/env raku

use Raku::Recipes::Classy;

sub MAIN( Bool :$Dairy, Bool :$Vegan, Bool :$Main, Bool :$Side, Bool :$Dessert ) {
    my %ingredients = Raku::Recipes::Classy.new().calories-table;
    my @flags = <Dairy Vegan Main Side Dessert>.grep: { defined ::{"\$$_"} };
    say %ingredients.keys.grep: -> $i {
        so all @flags.map:  { %ingredients{$i}{$_} eq ::{"\$$_"} };
    }
}
