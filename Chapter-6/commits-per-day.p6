#!/usr/bin/env raku

use Git::Log;

git-log()<>
    ==> map( { DateTime.new( $_<AuthorDate> ).Date } )
    ==> classify( { $_ } )
    ==> map( { $_.key ~ ", " ~ $_.value.elems } )
    ==> sort()
    ==> my @dates;

say @dates.join( "\n" );

