#!/usr/bin/env perl6

use Raku::Recipes;
use Markit;
use Template::Classic;

my $template-name="templates/recipe.html";
my $template-file = "resources/$template-name".IO.e
                ??"resources/$template-name".IO.slurp
                !!%?RESOURCES{$template-name}.slurp;

my $md = Markdown.new;
my &generate-page := template :($content), $template-file;

for recipes() -> $recipe {
    my $html-fragment = recipe($md,$recipe);
    my @page = generate-page( $html-fragment );
    spurt-with-dir($recipe, @page.eager.join );
}

sub recipe( $md, $recipe ) {
    return  $md.markdown( $recipe.slurp );
}

sub spurt-with-dir( $file-path, $content ) {
    my $html-path-name = ~$file-path;
    $html-path-name ~~ s/\.md/\.html/;
    $html-path-name ~~ s/recipes/build/;
    my $html-path = IO::Path.new($html-path-name);
    my $html-dir = $html-path.dirname.IO;
    $html-dir.mkdir unless $html-dir.d;
    spurt $html-path-name,  $content;

}
