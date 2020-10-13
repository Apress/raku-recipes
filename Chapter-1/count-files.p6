#!/usr/bin/env perl6

use v6;

sub MAIN( $dir = '.' ) {
    say "There are ", tree( $dir )».List.flat.elems, " recipes";
}

sub tree( $dir ) {
    my @files = gather for dir($dir) -> $f {
        if ( $f.IO.f ) {
            take $f
        } else {
            take tree($f);
        }
    }
    return @files;
}
