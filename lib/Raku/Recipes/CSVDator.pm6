=begin pod

=head1 NAME

Raku::Recipes::CSVDator - Uses CSV to store and retrieve data

=head1 SYNOPSIS

=begin code
use Raku::Recipes::CSVDator;

class Raku::Recipes::Database does Raku::Recipes::Dator {
      # redefines ingredients and products
}
=end code

=head1 DESCRIPTION

Data role that has the attributes and basic interface for data-loading and
handling, destined to be mixed into actual classes that handle data.


=end pod

use Text::CSV;
use Raku::Recipes::Dator;
use Raku::Recipes;
use X::Raku::Recipes::Missing;

#| Basic calorie table handling role
unit class Raku::Recipes::CSVDator does Raku::Recipes::Dator;

#| Contains the table of calories
has %.ingredients;

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
    my %ingredients = csv(in => $calorie-table-file,
            sep => ';',
            headers => "auto",
            key => "Ingredient" ).pairs
            ==> map( {
        $_.value<Ingredient>:delete;
        $_.value<parsed-measures> = parse-measure( $_.value<Unit> );
        $_ } );

    for %ingredients.values -> %ingredient {
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
    self.bless( :%ingredients );
}

method get-ingredient( Str $ingredient ) {
    return %!ingredients{$ingredient}
            // X::Raku::Recipes::Missing::Product.new( name => $ingredient ).throw
}

method get-ingredients() {
    return %!ingredients;
}

method search-ingredients( %search-criteria ) {
    %!ingredients.keys.grep:
            { search-table(  %!ingredients{$_},%search-criteria) };
}

method insert-ingredient( Str $ingredient, %data ) {
    die "Ingredients are immutable in this class";
}

method delete-ingredient( Str $ingredient) {
    die "Ingredients are immutable in this class";
}