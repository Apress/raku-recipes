use Test; # -*- mode: perl6 -*-

use Raku::Recipes::Classy;

my $rr = Raku::Recipes::Classy.new( "." );

my @products = $rr.products;
my %calories-table = $rr.calories-table;

is( %calories-table{@products[0]}<Dairy>, True|False, "Values processed" );

cmp-ok( @products.elems, ">", 1, "Many elements in the table" );
ok( %calories-table<Rice>, "Rice is there" );
is( %calories-table<Rice><parsed-measures>[1], "g", "Measure for rice is OK" );

is $rr.proteins( <Rice Chickpeas> ), 9.7, "Proteins computed correctly";

cmp-ok $rr.filter-ingredients( :Dairy ).elems, ">", 0, "Enough dairy ingredients";
cmp-ok $rr.filter-ingredients( :!Dairy, :Vegan ).elems, ">", 5, "Enough non-dairy, vegan ingredients";

subtest "Test declarator blocks", {
    ok Raku::Recipes::Classy.WHY, "Class described";
    ok Raku::Recipes::Classy.new.^lookup('filter-ingredients').WHY, "Declarator blocks retrieved";
}
done-testing;
