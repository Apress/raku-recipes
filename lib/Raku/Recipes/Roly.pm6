use Text::CSV;
use Raku::Recipes;
use X::Raku::Recipes::Missing;

=begin pod

=head1 NAME

Raku::Recipes::Roly - Example of a Role, which includes also utility functions for Raku Recipes book (by Apress)

=head1 SYNOPSIS

=begin code
use Raku::Recipes::Roly;

my $rrr = Raku::Recipes::Roly.new; # "Puns" role with the default data dir

say $rrr.calories-table; # Prints the loaded calorie table
say $rrr.products;       # Prints the products that form the set of ingredients
=end code

=head1 DESCRIPTION

Simple data-loading role that can be composed into classes that will deal with tables of ingredients, every one with tabular data.

=head1 CAVEATS

The file needs to be called C<calories.csv> and be placed in a C<data/> subdirectory.

=end pod

our $pod is export = $=pod[0];

#| Basic calorie table handling role
unit role Raku::Recipes::Roly:ver<0.0.3>;

#| Contains the table of calories
has %.calories-table;

#| Products or ingredients will be stored for brevity here
has @.products;

#|[
Creates a new calorie table, reading it from the directory indicated,
the current directory by default. The file will be in a subdirectory data,
and will be called calories.csv
]
method new( $dir = "." ) {
    my $calorie-table-file = %*ENV<CALORIE_TABLE_FILE>
       // "$dir/data/calories.csv";
    X::Raku::Recipes::Missing::File.new(:name($calorie-table-file)).throw
            unless $calorie-table-file.IO.e;
    my %calories-table = csv(in => $calorie-table-file,
                             sep => ';',
                             headers => "auto",
                             key => "Ingredient" ).pairs
    ==> map( {
       $_.value<Ingredient>:delete;
       $_.value<parsed-measures> = parse-measure( $_.value<Unit> );
       $_ } );

    for %calories-table.values -> %ingredient {
        for %ingredient.keys -> $k {
            given  %ingredient{$k} {
                when "Yes" { %ingredient{$k} = True }
                when "No"  { %ingredient{$k} = False };
            }
        }
        for @food-types -> $f {
            %ingredient<types> ∪= $f if %ingredient{$f};
        }
    };
    @products = %calories-table.keys;
    self.bless( :%calories-table, :@products );
}

#| Basic getter for products
method products () { return @!products };
#= → Returns an array with the existing products.

#| Basic getter for the calorie table
method calories-table() { return %!calories-table };

#| Checks if a product exist
proto method is-ingredient( | ) {*}
multi method is-ingredient( Str $product where $product ∈ self.products() -->
        True) {}
multi method is-ingredient( Str $product where $product ∉ self.products() -->
        False) {}

#| Check type of ingredient
method check-type( Str $ingredient where $ingredient ∈ %!calories-table.keys,
		   Str $type where $type ∈ @food-types --> Bool ) {
    return %!calories-table{$ingredient}{$type};
}

#| Check type of ingredient
method check-unit( Str $ingredient where $ingredient ∈ %!calories-table.keys,
                   Str $unit where $unit ∈ @unit-types --> Bool ) {
    return %!calories-table{$ingredient}<parsed-measures>[1] eq $unit;
}