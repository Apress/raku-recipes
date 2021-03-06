#!/usr/bin/env perl6

my Int @primes = (2⁶⁴…∞).grep: *.is-prime;

my $prev = 0;
my @contiguous = lazy gather {
    for @primes -> $prime {
	take [$prime, $prev] if $prime - $prev == 2;
	$prev=$prime;
    }
}

say @contiguous[^3];
