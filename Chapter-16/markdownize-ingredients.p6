#!/usr/bin/env perl6

use RecipeMark;
use URI::Encode;

my $recipemark = RecipeMark.new( @*ARGS[0]
        // "recipes/main/rice/tuna-risotto.md" );

my %ingredients = $recipemark.ingredient-list;
say %ingredients.raku;
my @ingredients = gather for %ingredients.kv -> $product, %data {
    take "* %data<quantity> %data<unit> "
        ~ "[ {lc $product} ](/Ingredient/" ~ uri_encode($product) ~ ")"
                    ~ (" %data<options>" if %data<options>);
}

my @instructions = gather for $recipemark.instruction-list[0][] -> $instruction {
    take $instruction.key ~ ". " ~ "*" ~ $instruction.value.key ~ "* "
            ~ $instruction.value.value ~ ".";
}

say @ingredients.join( "\n" ), "\n", @instructions.join("\n");