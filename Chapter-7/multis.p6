#!/usr/bin/env perl6

use Raku::Recipes;

%calories-table = calories-table();

multi sub how-many-calories( Str $description ){
    return samewith( | $description.split(/\s+/))
}

multi sub how-many-calories( Str $quantities, Str $product ) {
    my ($how-much, $unit ) = parse-measure( $quantities );
    return samewith( $how-much, $unit, $product )
}

multi sub how-many-calories( Int $how-much, Str $unit, Str $product ) {
    if %calories-table{$product}<parsed-measures>[1] eq $unit {
        return %calories-table{$product}<Calories> * $how-much
            / %calories-table{$product}<parsed-measures>[0];
    } else {
        die "Die $how-much $unit $product";
    }
}

sub gimme-calories( $first, $second?, $third?) {
    my ($product, $unit, $how-much);
    if $third {
        ($how-much, $unit, $product) = ($first, $second, $third);
    } elsif $second {
        ($how-much, $unit, $product) = (|parse-measure( $first ), $second);
    } else {
        my @parts = $first.split: /\s+/;
        ($how-much, $unit, $product) = (|parse-measure( @parts[0] ), @parts[1])
    }

    if %calories-table{$product}<parsed-measures>[1] eq $unit {
        return %calories-table{$product}<Calories> * $how-much
                / %calories-table{$product}<parsed-measures>[0];
    } else {
        fail;
    }
}

my @measures = 1000.rand.Int xx 10000;
my @food = <Rice Tuna Lentils>;
my @final = @measures.map( {$_ ~ "g "})  X~ @food;

my $start = now;
for @final {
    my $calories = how-many-calories($_) ;
}
say now - $start;

$start = now;
for @final {
    my $calories = gimme-calories($_);
}
say now - $start;

$start = now;
for @measures X @food {
    my $calories = how-many-calories( @_[0].Int, "g", @_[1]) ;
}
say now - $start;

$start = now;
for @measures X @food {
    my $calories = gimme-calories( @_[0].Int, "g", @_[1] );
}
say now - $start;
