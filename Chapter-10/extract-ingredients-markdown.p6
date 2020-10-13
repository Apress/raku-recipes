#!/usr/bin/env perl6

use Text::Markdown;

sub MAIN( $filename = "recipes/appetizers/carrot-wraps.md") {
    my $md = parse-markdown-from-file($filename);
    my @ingredients = $md.document.items
            .grep( Text::Markdown::List )
            .grep( !*.numbered );
    for @ingredients[0].items -> $i {
        say "Ingredient → {(~$i).trim}";
    };
}