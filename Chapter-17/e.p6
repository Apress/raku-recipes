#!/usr/bin/env perl6

say [+] (1,| [\*] (1…∞))[^@*ARGS[0]].map: 1/*