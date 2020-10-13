#!/usr/bin/env raku

use Text::Diff::Sift4;


constant $prefix = "recipes/main/rice/";
say sift4( "$prefix/tuna-risotto.md".IO.slurp, "$prefix/tuna-risotto-low-cost.md".IO.slurp, 100, 400);

