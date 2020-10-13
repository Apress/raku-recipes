use Test; # -*- mode: perl6 -*-

use Raku::Recipes::Grammar::Measured-Ingredients;
use Raku::Recipes::Grammar::Actions;

subtest "Test items", {
    my $item = Raku::Recipes::Grammar::Measured-Ingredients.parse("2 egg",
            actions =>
            Raku::Recipes::Grammar::Actions::Measured-Ingredients.new);

    with $item.made {
        ok($_, "Ingredient parsed");
        is(.key, "Egg", "Ingredient parsed OK");
        is(.value.WHAT, Pair, "Value parsed");
        is(.value.key, "Unit", "Unit parsed");
        is(.value.value, 2, "Measure parsed");
    }

    throws-like
            { Raku::Recipes::Grammar::Measured-Ingredients.parse("2g apple",
                    actions =>
                    Raku::Recipes::Grammar::Actions::Measured-Ingredients.new);
            },
        X::Raku::Recipes::WrongUnit,
        "Raises error with wrong unit";
}
done-testing;
