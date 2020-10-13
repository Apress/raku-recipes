#!/usr/bin/env raku

use Math::Matrix;

my $first = Math::Matrix.new( [[1,2],[3,4]] );

my $second = $first * 2;

say $second + $first;
