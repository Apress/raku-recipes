use Test;
use RecipeMark::Grammar;
use Grammar::PrettyErrors;

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

my $rm = RecipeMark::Grammar.new;
subtest "Subparse", {
    my $description = "A relatively simple version of this rich, creamy dish of
Italian origin.";
    is $rm.subparse($description, rule => "sentence" ), $description,
            "Sentence subparsing working";
    is $rm.subparse($description, rule => "description" ), $description,
            "Description subparsing working";
    my $title = "Boiled fishtails";
    is $rm.subparse($title, rule => "title" ), $title,
            "Title subparsing working";

    my $verb = "Stir-fry";
    check-rule( $rm, $verb, "action-verb" );
    my $instruction = "$verb garlic until golden-colored, chopped if you so  like, retire if you don't like the color.";
    for substr($instruction, 0, *-1).split: / ","?\h+ / -> $w {
        is $rm.subparse( $w, rule => "words" ), $w, "Parsing $w";
    }
    my $match= check-rule($rm, $instruction, "instruction");
    is $match<action-verb>, $verb, "Sub-instruction parsing";

    my $*LAST = 0; # Needed to avoid errors.
    my $numbered-instruction = "2. $instruction";
    $match = check-rule( $rm, $numbered-instruction, 'numbered-instruction');
    is $match<numbering>, "2", "Numbering";

    my $instructions = q:to/EOC/.chomp;
1. Slightly-fry tuna with its own oil it until it browns a bit, you can do this while you start doing the rest, save a bit of oil for the rice.
1. Stir-fry garlic until golden-colored, chopped if you so like, retire if you don't like the color.
2. Add finely-chopped onion, and stir-fly until transparent.
3. Add rice and stir-fry until grains become transparent in the tips.
4. Add wine or beer and stir until it's absorbed by grains.
EOC

    check-rule( $rm, $instructions,  'instruction-list');
    my $*INGREDIENTS = set();
    check-rule( $rm, "* ½ onion", "itemized-ingredient" );

    my $ingredient-list = q:to{END};
* 4 cloves garlic
* 1 spoon butter (or margarine)
* ⅓ liter wine (or beer)
END
    check-rule( $rm, $ingredient-list.chomp, 'ingredient-list');

}

subtest "Parse", {
    ok $rm.parse( $str.chomp ), "Whole parsing works";
}

subtest "Errors", {
#    say $rm.parse( $str.subst("tuna", "piranha").chomp );
    throws-like { $rm.parse( $str.subst("tuna", "piranha").chomp ) },
    X::Grammar::PrettyError, lastrule => 'separation',
    "Inexistent product throws";

    throws-like {
        $rm.parse($str.subst("7.", "5.").chomp)
    }, X::RecipeMark::OutOfOrder, last => 6,
            "Numbering taken care of";

    throws-like {
        $rm.parse($str.subst("rice", "tuna").chomp)
    }, X::RecipeMark::RepeatedIngredient, name => "Tuna",
            "Ingredients taken care of";

}

done-testing;

#| Several checks for rules
sub check-rule(  RecipeMark::Grammar $rm,
                 Str $str, $rule ) {
    my $match = $rm.subparse( $str, rule => $rule );
    ok( $match, "Checking $rule");
    is( $match, $str, "Parsing with $rule correct");
    return  $match;
}