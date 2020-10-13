use Test; # -*- mode: perl6 -*-
use Raku::Recipes::Ingredients;

my @ingredients = ("100g tuna", "200g rice", "150g tomatoes");
my $ingredients = Raku::Recipes::Ingredients.new( :@ingredients );

ok( $ingredients, "Can instantiate");

class With-Ingredients does Raku::Recipes::Ingredients {};
my $ingredients-mostly = With-Ingredients.new( :@ingredients);
ok( $ingredients-mostly, "Baked in class");
like( $ingredients-mostly.gist, /"* " {@ingredients[0]} /, "Gist is OK" );
is( $ingredients-mostly.how-many, @ingredients.elems,
        "Number of ingredients correct");

done-testing;
