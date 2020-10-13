#!/usr/bin/env perl6

use Inline::Perl5;

use MealMaster:from<Perl5>;

use Raku::Recipes::Recipe;
use Raku::Recipes::SQLator;

use Recipr::Log::Timeline;
use Template::Classic;
use cmark::Simple;

my $threads = @*ARGS[0] // 2;

my Channel $queue .= new;

my $parser = MealMaster.new();
my @recipes = $parser.parse("Chapter-15/allrecip.mmf");

my %ingredients = Raku::Recipes::SQLator.new.get-ingredients;
my @known = %ingredients.keys.map: *.lc;

my &generate-page = template :($title,$content),
        template-file( "templates/recipe-with-title.html" );

my atomicint $serial = 1;
my %urls-for-known = | @known.map: { $_ => "[$_](/ingredient/$_)"};
say %urls-for-known;

my @promises = do for ^$threads {
    start react whenever $queue -> $recipe is copy {
        Recipr::Log::Timeline::Processing.log: -> {
            my @real-ingredients = $recipe.ingredients.grep( /^^\w+/)
            .map( {  $_ ~~ Blob ?? $_.decode !! $_ } );
            $recipe.ingredients = @real-ingredients;
            my $recipe-md = $recipe.gist;
            for @known -> $k {
                $recipe-md .= subst( /:i <|w> $k <|w>/, %urls-for-known{$k} )
            }
            Recipr::Log::Timeline::Saving.log: -> {
                "/tmp/recipe-$serial.html".IO.spurt(generate-page($recipe.title,
                        commonmark-to-html($recipe-md)).eager.join);
                say "Writing /tmp/recipe-$serial.html";
            }
            $serial⚛++;
        }
    }
}

await start for @recipes -> $r {
    Recipr::Log::Timeline::Emitting.log: -> {
        my $description = "Categories: " ~ $r.categories().join(" - ");
        my $title;
        if $r.title ~~ Str {
            $title = $r.title
        } else {
            $title = $r.title.decode
        }
        my $recipe = Raku::Recipes::Recipe.new(
                :$title,
                :$description,
                ingredients => $r.ingredients().map: { .product }
                );
        $queue.send: $recipe;
    }
}

$queue.close;

await @promises;

sub template-file( $template-file-name ) {
    "resources/$template-file-name".IO.e
            ??"resources/$template-file-name".IO.slurp
            !!%?RESOURCES{$template-file-name}.slurp;
}