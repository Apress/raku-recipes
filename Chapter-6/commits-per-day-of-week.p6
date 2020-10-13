#!/usr/bin/env raku

use Git::Log;

my @dow = <Nope Mon Tue Wed Thu Fri Sat Sun>;

git-log()<>
    ==> map( { DateTime.new( $_<AuthorDate> ).day-of-week } )
    ==> classify( { $_ } )
    ==> sort()
    ==> map( { @dow[$_.key] ~ ", " ~ $_.value.elems } )
    ==> my @dates;

say @dates.join( "\n" );

