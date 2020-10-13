use Test;
use RecipeMark;

my $recipe = RecipeMark.new("recipes/main/rice/tuna-risotto.md");
my @products = <Tuna Rice Onion Garlic Cheese Butter>;
@products.append($_) for "Olive oil", "Fish broth", "White wine";

ok( $recipe, "Created recipe");
isa-ok( $recipe, RecipeMark, "Correct class");
is( $recipe.ingredient-list.keys.elems, 9, "Correct ingredients");
ok( "Rice" ∈ $recipe.ingredient-list.keys, "Rice is there");
like  $recipe.to-json, /"\"title\":"/, "Correct JSON" ;
is @products.sort, $recipe.product-list.sort, "Got products";
done-testing;
