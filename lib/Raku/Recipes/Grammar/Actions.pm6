use Raku::Recipes::Roly;
use X::Raku::Recipes;

my $rrr = Raku::Recipes::Roly.new();

unit module Raku::Recipes::Grammar::Actions;

class Measured-Ingredients {
    method TOP($/) {
        my $unit = $/<unit>.made // "Unit";
        my $ingredient = $/<ingredient>.made;
        if ( $rrr.check-unit( $ingredient, $unit ) ) {
            make $ingredient =>  $unit => $/<quantity>.made;
        } else {
            X::Raku::Recipes::WrongUnit.new( desired-unit => 'Other',
                    unit => $unit ).throw;
        }
    }

    method ingredient($/) {
        make tc ~$/;
    }
    method quantity($/) {
        make +val( ~$/  ) // unival( ~$/ )
    }
    method unit($/){
        make ~$/;
    }

}