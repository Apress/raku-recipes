#!/usr/bin/env raku

use Text::CSV;

say csv(in => "data/calories.csv",  sep => ';', headers => "auto" );


