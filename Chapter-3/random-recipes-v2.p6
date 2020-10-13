#!/usr/bin/env raku

use Raku::Recipes;

%calories-table = calories-table;

my @main-course = %calories-table.keys.grep: { %calories-table{$_}<Main> eq 'Yes' };
my @side-dish   = %calories-table.keys.grep: { %calories-table{$_}<Side> eq 'Yes' };

given (@main-course X @side-dish).grep( { @_[0] ne @_[1] } ).pick {
    say "Your recipe → @_[0] with ", lc( @_[1] ), " on the side"
}
