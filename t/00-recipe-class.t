use Test; # -*- mode: perl6 -*-
use Raku::Recipes::Recipe;

my $description = "Very basic but flavourful dish";
my @ingredients = ("100g tuna", "200g rice", "150g tomatoes");
my $recipe = Raku::Recipes::Recipe.new( :title("Tuna with rice"),
        :$description,
        :@ingredients );

ok( $recipe, "Can instantiate");
is( $recipe.description, $description, "Description holds");
is( $recipe.ingredients.elems, 3, "Ingredients are OK");
like( $recipe.gist, /"* " {@ingredients[0]} /, "Gist is OK" );

done-testing;
