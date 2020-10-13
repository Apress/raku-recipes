#!/usr/bin/env perl6

use v6;

sub MAIN( $dir = '.' ) {
    my $supply = supply tree-emit( $dir );
    my @titles = gather {
	$supply.tap( -> $f { take $f.IO.lines.head } )
    };
    say "Recipes ⇒\n", @titles.join("\n");
    
}

sub tree-emit( $dir ) {
    for dir($dir) -> $f {
        if ( $f.IO.f ) {
	    emit $f
        } else {
	    tree-emit($f);
        }
    }
}
