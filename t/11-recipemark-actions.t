use Test;
use Raku::Recipes::Grammar::RecipeMark;
use Raku::Recipes::Grammar::RecipeMark::Actions;

my $str = q:to{EOC};
# Tuna risotto

A relatively simple version of this rich, creamy dish of Italian origin.

## Ingredients (for 4 persons)

* 320g tuna (canned)
* 250g rice
* ½ onion
* 250g cheese (whatever is in your fridge)
* 2 tablespoons olive oil
* 4 cloves garlic
* 1 spoon butter (or margarine)
* ⅓ liter wine (or beer)

## Preparation (75m)

1. Slightly-fry tuna with its own oil it until it browns a bit, you can
 do this while you start doing the rest, save a bit of oil for the rice.
1. Stir-fry garlic until golden-colored, chopped if you so like, retire if
 you don't like the color.
2. Add finely-chopped onion, and stir-fly until transparent.
3. Add rice and stir-fry until grains become transparent in the tips.
4. Add wine or beer and stir until it's absorbed by grains.
5. Repeat several times: add fish broth, stir, until water is evaporated, until rice is soft but a bit chewy.
6. Add tuna, butter, grated cheese, and turn heating off, removing until
 creamy.
7. Rest for 5 minutes before serving.
EOC

my $rm = Raku::Recipes::Grammar::RecipeMark.new;
subtest "Subparse", {
    my $description = "A relatively simple version of this rich, creamy dish of
Italian origin.";

    my $verb = "Stir-fry";
    my $instruction = "$verb garlic until golden-colored, chopped if you so  like, retire if you don't like the color.";
    my $numbered-instruction = "2. $instruction";
    my $result = $rm.subparse( $numbered-instruction,
            rule => "numbered-instruction",
            actions => Raku::Recipes::Grammar::RecipeMark::Actions.new );
    is $result.made.key, 2, "Parsed and made OK";


    my $instructions = q:to/EOC/.chomp;
1. Slightly-fry tuna with its own oil it until it browns a bit, you can do this while you start doing the rest, save a bit of oil for the rice.
1. Stir-fry garlic until golden-colored, chopped if you so like, retire if you don't like the color.
2. Add finely-chopped onion, and stir-fly until transparent.
3. Add rice and stir-fry until grains become transparent in the tips.
4. Add wine or beer and stir until it's absorbed by grains.
EOC

    $result = $rm.subparse( $instructions,
                    rule => "instruction-list",
                    actions => Raku::Recipes::Grammar::RecipeMark::Actions.new );
    is $result.made.elems, 5, "Number of instructions";
    is $result.made[0].key, 1, "First instruction OK";
    is $result.made[*-1].value.key, "Add", "Action verb extracted";

    my $ingredient-list = q:to{END}.chomp;
* 4 cloves garlic
* 1 spoon butter (or margarine)
* ⅓ liter wine (or beer)
END
    $result = $rm.subparse( $ingredient-list,
            rule => "ingredient-list",
            actions => Raku::Recipes::Grammar::RecipeMark::Actions.new );
    is $result.made.elems, 3, "Ingredient list size";
    is $result.made.[0].keys[0], "Garlic", "First ingredient";
    is $result.made[*-1].values[0]<unit>, "liter", "Last measure";
}

subtest "Parse", {
    my $result = $rm.parse( $str.chomp,
            actions => Raku::Recipes::Grammar::RecipeMark::Actions);
    ok $result.made, "Whole parsing works";
    is $result.made<preparation-minutes>, 75, "Preparation time";
    is $result.made.keys.elems, 6, "All keys in";
    say $result.made;
}
done-testing;
