use Test; # -*- mode: perl6 -*-

use Raku::Recipes::Classy;

my $rr = Raku::Recipes::Classy.new( "." );

my @products = $rr.products;
my %calories-table = $rr.calories-table;

my @optimal = $rr.optimal-ingredients( @products.elems -1 , 500 );
like @optimal[0], /\w+/, "Optimal protein combo";

done-testing;
