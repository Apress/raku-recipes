#!/usr/bin/env raku

use Algorithm::Diff;


constant $prefix = "recipes/main/rice/";
for sdiff( "$prefix/tuna-risotto.md".IO.lines, "$prefix/tuna-risotto-low-cost.md".IO.lines).rotor(3)
    -> ($mode, $deleted, $added ) {
    say qq:to/EO/ unless $mode eq 'u';
# $mode
    ← $deleted
    → $added
EO 

};

