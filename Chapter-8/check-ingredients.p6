#!/usr/bin/env perl6

use Raku::Recipes::Grammar::Ingredients;

my $row = Raku::Recipes::Grammar::Ingredients.parse("* 2 tbsps");
say "We need to use $row<row><ingredient><quantity> $row<row><ingredient><unit> of whatever"