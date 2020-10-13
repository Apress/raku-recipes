#!/usr/bin/env perl6

use Raku::Recipes::CSVDator;
use Raku::Recipes::SQLator;
use Raku::Recipes::Redisator;
use Raku::Recipes::Base;

sub MAIN( $ingredient, $type, $data-source = "Chapter-12/ingredients.sqlite3"
         ) {

    my $dator;
    if ( $data-source ~~ /\.sqlite3$/ ) {
        $dator = Raku::Recipes::SQLator.new( $data-source );
    } elsif ($data-source ~~ /\d+\:\d+/) {
        $dator = Raku::Recipes::Redisator.new( $data-source );
    } else {
        $dator = Raku::Recipes::CSVDator.new
    }
    my $checker = Raku::Recipes::Base.new( :$dator );

    say "$ingredient is ",
            $checker.check-type( $ingredient, $type ) ??""!!"not ",
            "of type $type";

}