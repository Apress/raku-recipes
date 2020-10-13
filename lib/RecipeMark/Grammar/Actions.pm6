unit class RecipeMark::Grammar::Actions;

method TOP($/) { make {
    title => ~$/<title>,
    description => ~$/<description>,
    persons => +$/<persons>,
    ingredient-list => $/<ingredient-list>.made,
    preparation-minutes => + $/<time>,
    instruction-list => $/<instruction-list>.made
} }

method ingredient-list( $/ ) {
    make gather for $/.hash<itemized-ingredient> ->
    $ingredient {
        take $ingredient.made
    }
}

method itemized-ingredient($/) { make $/<ingredient-description>.made }

method ingredient-description($/) {
    my %ingredient = $/<measured-ingredient>.made;
    %ingredient{%ingredient.keys[0]}{'options'} = ~$/<options><content>
        if $/<options>;
    make %ingredient;
}

method measured-ingredient($/) {
    make $/<product>.made => { unit => $/<unit>.made // "Unit",
                                quantity => $/<quantity>.made }
}

method product($/) { make tc ~$/; }
method quantity($/) { make +val( ~$/  ) // unival( ~$/ ) }
method options($/){ make ~$/; }
method unit($/){ make ~$/; }

method instruction-list( $/ ) {
    my @instructions = gather for $/.hash<numbered-instruction> ->
$instruction {
        take $instruction.made
    }
    make @instructions;
}
method numbered-instruction($/) {
    make $/<numbering>.made => $/<instruction>.made;
}
method numbering($/) { make +$/; }
method instruction($/) { make $/<action-verb>.made => $/<sentence>.made}
method action-verb($/) { make ~$/; }
method sentence($/) { make ~$/; }