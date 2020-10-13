#!/usr/bin/env perl6
use Red;
use Raku::Recipes::IngRedient;
use Raku::Recipes::SQLator;

my $*RED-DB = database "SQLite";
Raku::Recipes::IngRedient.^create-table;

my %data = Raku::Recipes::SQLator.new.get-ingredients;

for %data.kv -> $ingredient, %data {
    my %red-data;
    %red-data<name> = $ingredient;
    for %data.kv -> $key, $value is rw {
        given $value {
            when "Yes" { $value = True }
            when "No"  { $value = False }
        }
        %red-data{lc $key } = $value;
    }
    Raku::Recipes::IngRedient.^create: |%red-data;
}

say "Vegan ingredients →",
    Raku::Recipes::IngRedient.^all.grep( { .vegan } ).map( { .name  } )