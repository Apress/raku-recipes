#!/usr/bin/env raku

use Text::CSV;

csv(in => "data/calories.csv",  sep => ';', headers => "auto", key => "Ingredient" ).pairs
    ==> map( {
       $_.value<Ingredient>:delete;
       $_.value<parsed-measures> = parse-measure( $_.value<Unit> );
       $_ } )
    ==> my %calories;

my @recipes;
for dir("data/recipes/", test => /\.csv$/) -> $r {
    my %data = csv(in => $r.path, headers => "auto", key => "Ingredient").pairs
      ==> map( { $_.value<Ingredient>:delete; $_; } );
    push @recipes: %data;
    
}

say qq:to/END/;
Your non-caloric recipes add up to
{[+] (@recipes ==> map( { get-calories( $_ ) } ) ==> grep( * < 1600 ) )}
calories
END

sub parse-measure ( $description ) {
    $description ~~ / $<unit>=(<:N>*) \s* $<measure>=(\S+) /;
    my $unit = +$<unit>??+$<unit>!!1;
    return ($unit,~$<measure>);
}

sub get-calories( %recipe ) {
    my $total-calories = 0;
    for %recipe.keys -> $i {
        if %recipe{$i}<Unit> eq %calories{$i}<parsed-measures>[1] {
            $total-calories +=
            %calories{$i}<Calories> * %recipe{$i}<Quantity> / %calories{$i}<parsed-measures>[0]
        }
    }
    $total-calories;
}
