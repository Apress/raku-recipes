#!/usr/bin/env perl6

sub MAIN( Int $n =%*ENV<NUMBER> ) { my $ფ = 1; $ფ *= $_ for 1..$n; $ფ.say;}
