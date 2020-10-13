#!/usr/bin/env perl6

use Raku::Recipes;
use Markit;

my $md = Markdown.new;

for recipes() -> $recipe {
    my $html-path-name = ~$recipe;
    $html-path-name ~~ s/\.md/\.html/;
    $html-path-name ~~ s/recipes/build/;
    my $html-path = IO::Path.new($html-path-name);
    my $html-dir = $html-path.dirname.IO;
    $html-dir.mkdir unless $html-dir.d;
    say $html-dir;
    spurt $html-path-name,  $md.markdown( $recipe.slurp );
}
