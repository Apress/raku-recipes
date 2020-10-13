use Test; # -*- mode: perl6 -*-

use lib <lib t/lib>;
use RecipesTestHelp;

use X::Raku::Recipes;
use Raku::Recipes::Base;
use Raku::Recipes::SQLator;
use Raku::Recipes::CSVDator;
use Raku::Recipes::Redisator;

# Populate Redis, just in case
my $sqlator = Raku::Recipes::SQLator.new;
my %data = $sqlator.get-ingredients;
my $redisr = Raku::Recipes::Redisator.new;
for %data.kv -> $ingredient, %data {
    $redisr.insert-ingredient($ingredient,%data);
}

for ( Raku::Recipes::CSVDator,
      Raku::Recipes::Redisator,
      Raku::Recipes::SQLator) -> $class {
    test-with-dator( $class.new );
}

# Testing
sub test-with-dator ( $dator ) {

    my $rr = Raku::Recipes::Base.new(:$dator);

    my @products = $rr.products;
    my %calories-table = $rr.calories-table;

    subtest "File has been processed into data", {
        cmp-ok(@products.elems, ">", 1, "Many elements in the table");
    };

    subtest "Particular ingredients and measures are OK", {
        ok($rr.is-ingredient("Rice"), "Rice is a product");
        nok($rr.is-ingredient("Lint"), "Lint is not a product");
    };

    subtest "Food types are correct", {
        ok $rr.check-type("Tuna", "Main"), "Tuna is main";
        ok $rr.check-type("Rice", "Vegan"), "Rice is vegan";
        ok $rr.check-type("Apple", "Dessert"), "Apple is dessert";
        ok $rr.check-type("Egg", "Dairy"), "Egg is dairy";
    }

}

done-testing;
