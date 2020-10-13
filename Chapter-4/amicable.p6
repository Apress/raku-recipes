#!/usr/bin/env raku

use experimental :cached;

sub sum-divisors (Int $num) is cached {
    my @divisors = grep { $num %% $_ }, 2..($num / 2).Int;
    return [+] 1, | @divisors;
}

my @amicable = lazy gather {
    for 2..Inf -> $i {
	my $sum_div = sum-divisors $i;
	take [$i, $sum_div] if $sum_div > $i and $i == sum-divisors $sum_div;
    }
}

say @amicable[^4];
