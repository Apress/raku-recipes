#!/usr/bin/env perl6

use Test::Script;
use lib <.>;

for <factorial factorial-v2 factorial-v3 factorial-v4> -> $f {
    my $filename = "Chapter-17/$f.p6";
    output-is($filename, "3628800\n", "Output well computed for 10", args =>
    [10]);
}
