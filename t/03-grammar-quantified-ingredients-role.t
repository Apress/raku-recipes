use Test; # -*- mode: perl6 -*-

use Raku::Recipes::Grammarole::Measured-Ingredients;

my $ingredients = q:to/EOS/;
* 320g tuna (canned)
* 250g rice
* ½ onion
* 250g cheese (whatever is in your fridge)
* 2 tablespoons olive oil
* 4 cloves garlic
* 1 spoon butter (or margarine)
* ⅓ liter wine (or beer)
* 250g tuna
* 250g rice (carnaroli or arborio)
* ½ onion
* 125g cheese (parmegiano reggiano, granapadano or manchego)
* 1 tbsp olive oil (extra virgin)
* 4 cloves garlic
* ½ liter fish broth (or fumé)
* 1 cup white wine
* 2 spoons butter
EOS

grammar Tester does Raku::Recipes::Grammarole::Measured-Ingredients {}

subtest "Test alternatives",{
    for $ingredients.chomp.split: /\s* \* \s+/ -> $ingredient {
        my $item = Tester.subparse($ingredient,
                                    rule => "ingredient-description");
        is($item, $ingredient, "Parses $ingredient");
    }
}

subtest "Testing it's extracting stuff correctly", {
    my $item = Tester.subparse("½ onion",
            rule => "ingredient-description")<measured-ingredient>;
    is $item<quantity>, "½", "Quantity is correct";
    is $item<product>, "onion", "Product is correct";

    $item = Tester.subparse("⅓ liter wine (or beer)",
            rule => "ingredient-description");
    my $only-ingredient = $item<measured-ingredient>;
    is $only-ingredient<quantity>, "⅓", "Quantity is correct";
    is $only-ingredient<product>, "wine", "Product is correct";
    is $item<options><content>, "or beer", "Option is correct";
    is $only-ingredient<unit>, "liter", "Option is correct";
}

done-testing;
