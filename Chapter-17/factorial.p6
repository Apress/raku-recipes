#!/usr/bin/env perl6

say  [*] 1..( @*ARGS[0]
                // %*ENV<NUMBER>
                // die "Use $*PROGRAM <num> or NUMBER=<num> $*PROGRAM" );