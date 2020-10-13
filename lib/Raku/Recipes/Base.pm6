use Raku::Recipes;
=begin pod

=head1 NAME

Raku::Recipes::Base - Basic ingredient data and checking class for Raku
Recipes book (by Apress)

=head1 SYNOPSIS

=begin code
use Raku::Recipes::Base;


=end code

=head1 DESCRIPTION

Basic, data-store independent, ingredient checking class


=end pod

#| Basic calorie table handling role
unit role Raku::Recipes::Base;

#| Data access object
has $!dator;

submethod BUILD( :$!dator ) {}

#| Basic getter for products
method products () { return $!dator.get-ingredients.keys };
#= → Returns an array with the existing products.

#| Basic getter for the calorie table
method calories-table() { return $!dator.get-ingredients };

#| Checks if a product exist
proto method is-ingredient( | ) {*}
multi method is-ingredient( Str $product where $product ∈ self.products -->
        True) {}
multi method is-ingredient( Str $product where $product ∉ self.products -->
        False) {}

#| Check type of ingredient
method check-type( Str $ingredient where $ingredient ∈ self.products,
		   Str $type where $type ∈ @food-types --> Bool ) {
    return so $!dator.get-ingredient($ingredient){$type} eq "Yes" | True;
}

#| Check type of ingredient
method check-unit( Str $ingredient where $ingredient ∈ self.products,
                   Str $unit where $unit ∈ @unit-types --> Bool ) {
    return $!dator.get-ingredient($ingredient)<parsed-measures>[1] eq $unit;
}