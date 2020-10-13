#!/usr/bin/env perl6

use Raku::Recipes::Grammar::ErrorReporting;

my $measure = Raku::Recipes::Grammar::ErrorReporting.parse("* 2 tbsp");
say ~$measure<row><ingredient><quantity>, " of ",
        ~$measure<row><ingredient><unit>;
