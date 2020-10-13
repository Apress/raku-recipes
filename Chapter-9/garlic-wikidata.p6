#!/usr/bin/env perl6

use Wikidata::API;

my $query = "Chapter-9/ingredients.sparql".IO.slurp;

my $recipes-with-garlic= query($query);

say "Recipes with garlic:\n",
        $recipes-with-garlic<results><bindings>
            .map: { utf8y( $_<recipeLabel><value>) };

sub utf8y ( $str ) {
    Buf.new( $str.ords ).decode("utf8")
}