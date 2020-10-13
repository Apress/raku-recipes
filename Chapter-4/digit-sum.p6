#!/usr/bin/env raku

sub digits( $_1, $_2 ) {
    return $_1, $_2, { ($^a ~ $^b) % 9 }  ...  *;
}

for 1..5 X 1..5 -> @_ {
    say digits( | @_ )[^10];
}
