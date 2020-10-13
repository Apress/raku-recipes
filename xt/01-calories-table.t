use Test; # -*- mode: perl6 -*-

use Raku::Recipes;

%calories-table = calories-table( "." );
@products = %calories-table.keys;

my @optimal = optimal-ingredients( @products.elems -1 , 500 );
is @optimal[0], "Skyr drink" | "Garlic", "Optimal protein combo";

done-testing;
