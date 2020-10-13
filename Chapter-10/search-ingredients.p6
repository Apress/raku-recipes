#!/usr/bin/env perl6

use Data::StaticTable;
use Raku::Recipes::Texts;


my %recipes = Raku::Recipes::Texts.new().recipes;

my @recipes-table;
for %recipes.kv -> $title, %content {
    @recipes-table.append: [ $title,
                             %content<description>,
                             %content<ingredients>.join ];
}

my $recipes = Data::StaticTable.new(
        <Name Description Ingredients>,
        ( @recipes-table)
        );

my $recipe-query =  Data::StaticTable::Query.new($recipes); # Query object

$recipe-query.add-index( "Ingredients" );

my Data::StaticTable::Position @rice = $recipe-query.grep(rx/rice/,
        'Ingredients',n => True);
say $recipes.take( @rice ).display;