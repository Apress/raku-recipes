#!/usr/bin/env perl6

use v6;

say "Sentences → ", $*ARGFILES.lines.join("\n").split( / [ '.' | \v**2 ] / ).elems;

