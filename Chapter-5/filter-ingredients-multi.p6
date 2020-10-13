#!/usr/bin/env raku

use Raku::Recipes::Classy;

multi sub MAIN() {
    say Raku::Recipes::Classy.new.products;
}

multi sub MAIN( Bool :$Dairy, Bool :$Vegan, Bool :$Main, Bool :$Side, Bool :$Dessert ) {
    say Raku::Recipes::Classy.new.filter-ingredients( :$Dairy, :$Vegan, :$Main,  :$Side,  :$Dessert );
}
