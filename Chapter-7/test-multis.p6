#!/usr/bin/env perl6

use Raku::Recipes;

my @measures = 1000.rand.Int xx 10000;

my @units = <g l liter tablespoon>;

my @strings  = @measures X~ @units;
my @things = <Unit Clove Pinch>.pick xx 10000;

@strings.append: @things;

my $time = now;

for @strings {
    my $result = parse-measure( $_ );
}

say Duration.new(now - $time);

$time = now;

for @strings {
    my $result = unit-measure( $_ );
}

say Duration.new(now - $time);
