use Raku::Recipes;
use Raku::Recipes::Roly;
use X::Raku::Recipes::Missing;
use X::Raku::Recipes;

=begin pod

=head1 NAME

Raku::Recipes::Calorie-Computer - Class that's able to compute calories for
components

=head1 SYNOPSIS

=begin code
use Raku::Recipes::Calorie-Computer;

my $cc = Raku::Recipes::Calorie.new; # "Puns" role with the default data dir

say $cc.calories-table; # Prints the loaded calorie table
say $cc.products;       # Prints the products that form the set of ingredients
=end code

=head1 DESCRIPTION

Class able to do operations with calories

=head1 CAVEATS

The file needs to be called C<calories.csv> and be placed in a C<data/> subdirectory.

=end pod

#| Calorie computer with file loader
unit class Raku::Recipes::Calorie-Computer does Raku::Recipes::Roly;

#| Compute calories, given a product and a quantity. Raises exception if the
#| product does not exist.
multi method calories( Str $product is copy, $quantity) {
    $product = tc $product;
    X::Raku::Recipes::Missing::Product.new(:product($product)).throw
            unless $product ∈ self.products();
    return %!calories-table{$product}<Calories>*$quantity
            /%!calories-table{$product}<parsed-measures>[0];
}

#| Compute calories, given a Pair ingredient => unit => quantity
multi method calories( Pair $ingredient ) {
    return self.calories( $ingredient.key, $ingredient.value.value );
}

#| Computes calories for a dish composed of main and side.
#| Every one is a pair product, quantity
method calories-for( :$main, :$side) {
    X::Raku::Recipes::Missing::Product.new(:name($main.key)).throw
            unless self.is-ingredient($main.key);
    X::Raku::Recipes::WrongType.new(:product($main.key),
                                    :desired-type("Main")).throw
            unless self.check-type($main.key,"Main");
    X::Raku::Recipes::Missing::Product.new(:name($side.key)).throw
            unless self.is-ingredient($side.key);
    X::Raku::Recipes::WrongType.new(:product($side.key),
                                :desired-type("Side")).throw
            unless self.check-type($side.key,"Side");

    return self.calories( $main.key, $main.value ) +
            self.calories( $side.key, $side.value );

}