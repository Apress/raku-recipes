#!/usr/bin/env raku

use Raku::Recipes;

my %calories-table = calories-table;

my @main-course = %calories-table.keys.grep: { %calories-table{$_}<Main> eq 'Yes' };
my @side-dish = %calories-table.keys.grep: { %calories-table{$_}<Side> eq 'Yes' };

say "Your recipe ⇒ ", @main-course.pick, " with ", @side-dish.pick, " on the side";
