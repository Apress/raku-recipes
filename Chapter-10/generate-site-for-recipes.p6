#!/usr/bin/env perl6

use Raku::Recipes;
use Markit;
use Template::Classic;
use Text::Markdown;

my $md = Markdown.new;
my &generate-page = template :($title,$content),
                        template-file( "templates/recipe-with-title.html" );

my %links;
for recipes() -> $recipe {
    my $this-md = parse-markdown-from-file($recipe.path);
    my $html-fragment = recipe($md,$recipe);
    my $title = $this-md.document.items[0].text;
    note "Can't find title for $recipe" unless $title;
    my @page = generate-page( $title, $html-fragment );
    my $path = spurt-with-dir($recipe, @page.eager.join );
    $path .= subst( "build/", '' );
    %links{$path} = $title;
}

my &generate-index:= template :( %links ),
                        template-file( "templates/recipes-index.html" );

spurt("build/index.html", generate-index( %links ).eager.join);

sub template-file( $template-file-name ) {
    "resources/$template-file-name".IO.e
            ??"resources/$template-file-name".IO.slurp
            !!%?RESOURCES{$template-file-name}.slurp;
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
    return $html-path-name;
}
