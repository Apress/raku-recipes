#!/usr/bin/env raku

use File::Compare;


constant $prefix = "recipes/main/rice/";
say "Different" if files_are_different( "$prefix/tuna-risotto.md","$prefix/tuna-risotto-low-cost.md");
