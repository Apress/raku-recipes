#!/usr/bin/env perl6

use Raku::Recipes::CSVDator;
use Raku::Recipes::SQLator;
use X::Raku::Recipes::Missing;
use JSON::Fast;

sub MAIN( $ingredient, $data-source = "Chapter-12/ingredients.sqlite3" ) {

    my $dator;
    if ( $data-source ~~ /\.sqlite3$/ ) {
        $dator = Raku::Recipes::SQLator.new( $data-source );
    } else {
        $dator = Raku::Recipes::CSVDator.new;
    }
    say to-json( $dator.get-ingredient( tc($ingredient) ));
    CATCH {
        when X::Raku::Recipes::Missing {
            "We don't have info on $ingredient".say }
        default { say "Some error has happened"}
    }
}