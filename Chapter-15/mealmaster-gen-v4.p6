#!/usr/bin/env perl6

use Inline::Perl5;

use MealMaster:from<Perl5>;

use Raku::Recipes::Recipe;
use Raku::Recipes::SQLator;

use Template::Classic;
use cmark::Simple;

my $threads = @*ARGS[0] // 3;

my $parser = MealMaster.new();
my @recipes = $parser.parse("Chapter-15/allrecip.mmf");

my %ingredients = Raku::Recipes::SQLator.new.get-ingredients;
my @known = %ingredients.keys.map: *.lc;

my &generate-page = template :($title,$content),
        template-file( "templates/recipe-with-title.html" );

my %urls-for-known = | @known.map: { $_ => "[$_](/ingredient/$_)"};

@recipes.kv.rotor(2).map( { process-recipe(@_[0], @_[1]) } );

# Subs
sub template-file( $template-file-name ) {
    "resources/$template-file-name".IO.e
            ??"resources/$template-file-name".IO.slurp
            !!%?RESOURCES{$template-file-name}.slurp;
}

sub process-recipe( $serial, $recipe ) {
    my $description = "Categories: " ~ $recipe.categories().join(" - ");
    my $title;
    if $recipe.title ~~ Str {
        $title = $recipe.title
    } else {
        $title = $recipe.title.decode
    }
    my $rrecipe = Raku::Recipes::Recipe.new(
            :$title,
            :$description,
            ingredients => $recipe.ingredients().map: { .product }
            );
    my @real-ingredients = $rrecipe.ingredients.grep(/^^\w+/)
            .map({ $_ ~~ Blob ?? $_.decode !! $_ });
    $rrecipe.ingredients = @real-ingredients;
    my $recipe-md = $rrecipe.gist;
    for @known -> $k {
        $recipe-md .= subst(/:i <|w> $k <|w>/, %urls-for-known{$k})
    }
    "/tmp/recipe-$serial.html".IO.spurt(generate-page($rrecipe.title,
            commonmark-to-html($recipe-md)).eager.join);
    say "Writing /tmp/recipe-$serial.html";

}