=begin pod

=head1 NAME

Raku::Recipes::Dator - Abstract role for accessing data on ingredients

=head1 SYNOPSIS

=begin code
use Raku::Recipes::Dator;

class Raku::Recipes::Database does Raku::Recipes::Dator {
      # redefines ingredients and products
}
=end code

=head1 DESCRIPTION

Data role that has the attributes and basic interface for data-loading and
handling, destined to be mixed into actual classes that handle data.


=end pod

#| Basic data access abstract role
unit role Raku::Recipes::Dator;

method get-ingredient( Str $ingredient ) {…}
method get-ingredients() {…}
method products() { self.get-ingredients.keys }
method search-ingredients( %search-criteria ) {…}
method insert-ingredient( Str $ingredient, %data ) {…}
method delete-ingredient( Str $ingredient) {…}