use Test; # -*- mode: perl6 -*-

use lib <lib t/lib>;

use RecipesTestHelp;
use X::Raku::Recipes;
use X::Raku::Recipes::Missing;
use Raku::Recipes::Calorie-Computer;

my $cc = Raku::Recipes::Calorie-Computer.new( "." );

my @products = $cc.products;
my %calories-table = $cc.calories-table;

subtest "Particular ingredients and measures are OK", {
    test-ingredient-table( %calories-table);
    ok( $cc.is-ingredient("Rice"), "Rice is a product");
    nok( $cc.is-ingredient("Lint"), "Lint is not a product");
    is( %calories-table<Rice><parsed-measures>[1], "g", "Measure for rice is OK" );
    throws-like  { $cc.calories("boogers",100) },
            X::Raku::Recipes::Missing::Product,
            "Not an ingredient";
    is( $cc.calories("Rice",300), 390, "Correct calories for rice");
    is( $cc.calories("Rice" => "g" => 300), 390, "Correct calories for Pair");
};

subtest "Composing dishes", {
    throws-like { $cc.calories-for( main => "Whatever" => 300,
            side => "Whatever" => 3
            ) },
            X::Raku::Recipes::Missing::Product, "Whatever not a product";
    throws-like { $cc.calories-for( main => "Apple" => 300,
            side => "Whatever" => 3
            ) },
          X::Raku::Recipes::WrongType, "Apple not a main dish";
    is( $cc.calories-for( main => "Tuna" => 250,
            side => "Rice" => 100  ), 455, "Calories for dish
computed correctly");
}

done-testing;
