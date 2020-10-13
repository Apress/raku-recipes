#!/usr/bin/env raku

use Parser::FreeXL::Native;

my %ingredients = %( Rice => g => 350,
                     Tuna =>  g => 400 ,
                     Cheese => g => 200 );

my Parser::FreeXL::Native $xl-er .= new;

$xl-er.open("data/calories.xls");
$xl-er.select_sheet(0);

my $total-calories = 0;
for 1..^$xl-er.sheet_dimensions[0] -> $r {
    my $ingredient = $xl-er.get_cell($r,0).value;
    if %ingredients{$ingredient} {
       my ($q, $unit )= extract-measure($xl-er.get_cell($r,1).value);
       if %ingredients{$ingredient}.key eq $unit  {
	   $total-calories += $xl-er.get_cell($r,2).value
	                   * %ingredients{$ingredient}.value / $q;
       }
   } 
}

say "Total calories ⇒ $total-calories";

sub extract-measure( $str ) {
    $str ~~ /^^ $<q> = ( <:N>* ) \s* $<unit>=(\w+)/;
    my $value = val( ~$<q> ) // unival( $<q> );
    return ($value,~$<unit>)
}
