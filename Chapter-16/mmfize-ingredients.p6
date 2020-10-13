#!/usr/bin/env perl6

use RecipeMark;
use URI::Encode;

my $recipemark = RecipeMark.new( @*ARGS[0]
        // "recipes/main/rice/tuna-risotto.md" );

my %units =  tbsp => "ts",
             Unit => "ea",
             spoons => "sp",
             cloves => "ea",
             cup => "cu",
             liter => "l" ;
my %ingredients = $recipemark.ingredient-list;
my @ingredients = gather for %ingredients.kv -> $product, %data {
    my $quantity = %data<quantity> ~~ Rat
            ?? %data<quantity>.Num
            !! %data<quantity>;
    say $quantity;
    my $unit = %data<unit>.chars > 2
            ?? %units{%data<unit>}
            !! %data<unit>;
    say %data, $unit;
    take $quantity.fmt("%7s") ~ " " ~ $unit.fmt("%2s") ~ " "
            ~ lc $product ~ "\n"
}
say @ingredients.join( "\n" ), "\n";