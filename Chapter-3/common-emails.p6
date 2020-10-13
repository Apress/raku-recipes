#!/usr/bin/env raku

say [∩] do .lines for dir( @*ARGS[0] // "emails", test => /txt$/ );

