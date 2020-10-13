use Test; # -*- mode: perl6 -*-

use Raku::Recipes;

my @all-recipes = recipes();
ok( @all-recipes, "There are recipes" );
ok( @all-recipes.grep( /desserts/), "There are desserts" );
ok( @all-recipes.grep( /rice/), "There is rice" );
ok( .IO.e, "$_ → file exists") for @all-recipes;

done-testing;
