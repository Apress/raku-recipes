#!/usr/bin/env perl6

say [+] (1,| [\*] (1…^max(@*ARGS[0],20))).map: 1.0/*