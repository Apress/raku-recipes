#!/usr/bin/env perl6

use Raku::Recipes::CSVDator;
use X::Raku::Recipes::Missing;
use JSON::Fast;

sub MAIN( $ingredient ) {
    my $dator = Raku::Recipes::CSVDator.new;
    say to-json( $dator.get-ingredient( tc($ingredient) ));
    CATCH {
        when X::Raku::Recipes::Missing {
            "We don't have info on $ingredient".say }
        default { say "Some error has happened"}
    }
}