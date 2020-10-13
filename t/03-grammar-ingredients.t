use Test; # -*- mode: perl6 -*-

use Raku::Recipes::Grammar::Ingredients;

subtest "Test quantities", {
    is( Raku::Recipes::Grammar::Ingredients.subparse( "⅓",
            rule => 'quantity'),
            "⅓", "Parses fractions" );
    is( Raku::Recipes::Grammar::Ingredients.subparse( "333",
            rule => 'quantity'),
            "333", "Parses integers" );
}

subtest "Test units", {
    is( Raku::Recipes::Grammar::Ingredients.subparse( "g",
            rule => 'unit'),
            "g", "Parses grams" );
    is( Raku::Recipes::Grammar::Ingredients.subparse( "clove",
            rule => 'unit'),
            "clove", "Parses integers" );
}

subtest "Test ingredients", {
    my $_300g = Raku::Recipes::Grammar::Ingredients.subparse( "300g",
            rule => 'ingredient');
    is( $_300g, "300g", "Parses 300g" );
    is( +$_300g<quantity>, 300, "Parses number OK");
    is( ~$_300g<unit>, "g", "Parses unit OK");
    my $_1-clove = Raku::Recipes::Grammar::Ingredients.subparse( "1 clove",
            rule => 'ingredient');
    is( $_1-clove, "1 clove", "Parses ingredients" );
    is( +$_1-clove<quantity>, 1, "Parses number OK");
    is( ~$_1-clove<unit>, "clove", "Parses unit OK");
}

subtest "Test items", {
    my $item = Raku::Recipes::Grammar::Ingredients.parse("* 2 tbsps");
    is( $item, "* 2 tbsps", "Parses item");
    say $item.raku;
    is( +$item<row><ingredient><quantity>, 2, "Parses number OK");
    is( $item<row><ingredient><unit>, "tbsps", "Parses unit OK");

}
done-testing;
