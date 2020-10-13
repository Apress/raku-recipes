use Test; # -*- mode: perl6 -*-

use Raku::Recipes;

%calories-table = calories-table( "." );
@products = %calories-table.keys;

cmp-ok( @products.elems, ">", 1, "Many elements in the table" );
ok( %calories-table<Rice>, "Rice is there" );
is( %calories-table<Rice><parsed-measures>[1], "g", "Measure for rice is OK" );

is proteins( <Rice Chickpeas> ), 9.7, "Proteins computed correctly";
@products .= sort;
is @products[0], "Apple", "Sorted products";
is unit-measure( "100g" ), (100,"g"), "Unit with number";

my ($unit, $measure) = unit-measure( "⅓ liter" );
is $measure, "liter", "Space and unicode";
is-approx $unit, ⅓, "Space and unicode - unit";

is unit-measure( "unit" ), (1,"unit"), "No number here";

my @vegan = search-ingredients(%calories-table, { Vegan => "Yes" });
ok(@vegan, "Searching works");
say @vegan;
cmp-ok(@vegan.elems, ">=", 1, "Elements are OK");
nok(search-ingredients(%calories-table,{ :Vegan("Yes"), :Dairy("Yes") }),
        "No vegan and dairy");
my @vegan'n'dessert =
        search-ingredients(%calories-table,{ :Vegan("Yes"), :Dessert("Yes")});
cmp-ok(@vegan'n'dessert, "⊆", @vegan, "Vegan desserts are vegan");

done-testing;
