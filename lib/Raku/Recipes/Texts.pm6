use Raku::Recipes;
use Text::Markdown;
use Markit;
use Template::Classic;

unit class Raku::Recipes::Texts;

has %.recipes;

method new( $dir where .IO.d  = "recipes") {
    my %recipes;
    for recipes( $dir ) -> $r {
        my $this-md = parse-markdown-from-file($r.path);
        my $title = $this-md.document.items[0].text;
        my $description = $this-md.document.items[1].items.join;
        my @ingredients = $this-md.document.items
            .grep( Text::Markdown::List )
            .grep( !*.numbered )
            .map( *[0].items.map: *.Str );
        %recipes{$title} = { description => $description,
                             ingredients => @ingredients[0].list,
                             path => $r.path }

        }
    self.bless( :%recipes );

}

method generate-site( $build-dir is copy = "build/") {
    $build-dir ~= "/" unless $build-dir ~~ m{"/"$$};
    my $md = Markdown.new;
    my &generate-page := template :($title,$content),
            template-file( "templates/recipe-with-title.html" );

    my %links;
    for %!recipes.kv -> $title, %value {
        my $recipe-fn = %value<path>;
        my $this-md = parse-markdown-from-file( $recipe-fn );
        my $html-fragment = recipe($md,$recipe-fn.IO);
        my @page = generate-page( $title, $html-fragment );
        my $path = spurt-with-dir($recipe-fn, @page.eager.join );
        %links{$path .= subst( $build-dir, '' )} = $title;
    }

    my &generate-index:= template :( %links ),
            template-file( "templates/recipes-index.html" );

    spurt($build-dir ~ "index.html", generate-index( %links ).eager.join);
}

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
