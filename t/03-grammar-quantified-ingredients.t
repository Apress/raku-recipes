use Test; # -*- mode: perl6 -*-

use Raku::Recipes::Grammar::Measured-Ingredients;

subtest "Test quantities", {
    is( Raku::Recipes::Grammar::Measured-Ingredients.subparse( "⅓",
            rule => 'quantity'),
            "⅓", "Parses fractions" );
    is( Raku::Recipes::Grammar::Measured-Ingredients.subparse( "333",
            rule => 'quantity'),
            "333", "Parses integers" );
}

subtest "Test units", {
    is( Raku::Recipes::Grammar::Measured-Ingredients.subparse( "g",
            rule => 'unit'),
            "g", "Parses grams" );
    is( Raku::Recipes::Grammar::Measured-Ingredients.subparse( "clove",
            rule => 'unit'),
            "clove", "Parses integers" );
}

subtest "Test items", {
    my $item = Raku::Recipes::Grammar::Measured-Ingredients.parse("2 egg");
    is( $item, "2 egg", "Parses item");
    is( +$item<quantity>, 2, "Parses number OK");
    is( $item<ingredient>, "egg", "Parses ingredient OK");

    $item = Raku::Recipes::Grammar::Measured-Ingredients.parse("150g Tuna");
    is( $item, "150g Tuna", "Parses item");
    is( +$item<quantity>, 150, "Parses number OK");
    is( $item<unit>, "g", "Parses unit OK");
    is( $item<ingredient>, "Tuna", "Parses ingredient OK");

}

subtest "Test alternatives",{
    my $ingredient = "2 eggs (free run)";
    my $item =
            Raku::Recipes::Grammar::Measured-Ingredients.parse( $ingredient );
    is( $item, $ingredient, "Parses item" );
}
done-testing;
