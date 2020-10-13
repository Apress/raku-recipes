use Test;
use Raku::Recipes;
use X::Raku::Recipes::Missing;

unit module RecipesTestHelp;

sub test-dator( $dator ) is export {
    my %ingredients = $dator.ingredients;
    my @products = %ingredients.keys;

    subtest "File has been processed into data", {
        is(%ingredients{@products[0]}<Dairy>, True | False, "Values processed");
        cmp-ok(@products.elems, ">", 1, "Many elements in the table");
    };

    subtest "Particular ingredients and measures are OK", {
        test-ingredient-table(%ingredients);
        is($dator.get-ingredient("Rice"), %ingredients<Rice>,
        "Single ingredient retrieved");
        is(%ingredients<Rice><parsed-measures>[1], "g", "Measure for rice is
OK");
        throws-like { $dator.get-ingredient("Goo") },
                X::Raku::Recipes::Missing::Product,
                "Correct exception thrown";
    };

    subtest "Search works", {
        my @vegan = $dator.search-ingredients({ Vegan => True });
        ok(@vegan, "Searching works");
        cmp-ok(@vegan.elems, ">=", 14, "Elements are OK");
        nok($dator.search-ingredients({ :Vegan, :Dairy }), "No vegan and dairy");
        my @vegan'n'dessert = $dator.search-ingredients({ :Vegan, :Dessert });
        cmp-ok(@vegan'n'dessert, "⊂", @vegan, "Vegan desserts are vegan")
    }
}

sub test-ingredient-table( %table ) is export {
    ok( %table<Rice>, "Rice is there" );
    is( %table<Rice><types>.elems, 4, "Rice food types");

}

sub test-insert-retrieve($dator, $ingredient, %data ) is export {
    lives-ok { $dator.insert-ingredient( $ingredient, %data) },
            "Can insert «$ingredient»";

    my %retrieved-data = $dator.get-ingredient($ingredient);
    ok( %retrieved-data, "Retrieves ingredient «$ingredient»...");
    is-deeply( %retrieved-data, %data, "... and does it correctly");
    return %retrieved-data;
}