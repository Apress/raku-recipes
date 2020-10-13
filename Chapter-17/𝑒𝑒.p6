#!/usr/bin/env perl6

say [+] (1,| [\*] (1..@*ARGS[0])).map: { FatRat.new(1,$_) }