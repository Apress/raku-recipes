#!/usr/bin/env raku

use Text::CSV;

my %calories = csv(in => "data/calories.csv",  sep => ';', headers => "auto", key => "Ingredient" );

%calories.keys
    ==> map( { %calories{$_}<Ingredient>:delete } )
    ==> grep( { %calories{$_}<Dairy> eq 'No'} )
    ==> my @non-dairy-ingredients;

%calories.keys 
    ==> map( { %calories{$_}<Dairy>:delete } );

say %calories{ @non-dairy-ingredients}.map: { parse-measure( $_<Unit> ) };

sub parse-measure ( $description ) {
    $description ~~ / $<unit>=(<:N>*) \s* $<measure>=(\S+) /;
    my $unit = $<unit> // 1;
    return ($unit,$<measure>);
}


