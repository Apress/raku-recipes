#!/usr/bin/env raku

use Raku::Recipes::Roly;

my $recipes = Raku::Recipes::Roly.new;

subset Main of Str where {
    $_ ∈ $recipes.products && $recipes.check-type($_, "Main" )
};
subset Side of Str where {
    $_ ∈ $recipes.products && $recipes.check-type($_, "Side" )
};

sub MAIN( Int :$calories = 500,
            Main :$main!,
            Side :$side! ) {
    my @recipe;
    for <main side> -> $part {
        my $this-value = ::{"\$$part"};
        my %this-product = $recipes.calories-table{$this-value};
        my $portion = $calories/( 2 * %this-product<Calories>);
        @recipe.push: $portion *  %this-product<parsed-measures>[0] ~ " " ~
                %this-product<parsed-measures>[1] ~ " of " ~  $this-value.lc;
    }

    say "Use ", @recipe.join(" and ");
}

