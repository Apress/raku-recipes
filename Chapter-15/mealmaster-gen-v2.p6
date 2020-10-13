#!/usr/bin/env perl6

use Inline::Perl5;

use MealMaster:from<Perl5>;

use Raku::Recipes::Recipe;
use Raku::Recipes::SQLator;

use Recipr::Log::Timeline;
use URI::Encode;
use Template::Classic;
use cmark::Simple;

my $threads = @*ARGS[0] // 5;

my Channel $queue .= new;

my $parser = MealMaster.new();
my @recipes = $parser.parse("Chapter-15/allrecip.mmf");

my %ingredients = Raku::Recipes::SQLator.new.get-ingredients;
my @known = %ingredients.keys.map: *.lc;

my &generate-page = template :($title,$content),
        template-file( "templates/recipe-with-title.html" );

my @promises = do for ^$threads {
    start react whenever $queue -> ($serial, $recipe) is copy {
        Recipr::Log::Timeline::Processing.log: -> {
            my @real-ingredients = $recipe.ingredients.grep: /^^\w+/;
            my @processed = gather for @real-ingredients -> $i is copy {
                $i = $i ~~ Blob ?? $i.decode !! $i;
                if $i ~~ m:i/ <|w> $<ingredient> = (@known) <|w>/ {
                    my $ing = ~$<ingredient>;
                    my $subst = "[$ing](/ingredient/" ~ uri_encode($ing.lc) ~
                    ")";
                    $i ~~ s:i!<|w> $ing <|w> ! $subst !;
                }
                take $i;
            }
            $recipe.ingredients = @processed;
            "/tmp/recipe-$serial.html".IO.spurt(
                    generate-page($recipe.title,
                                  commonmark-to-html($recipe.gist)
                                  ).eager.join
                    );
            say "Writing /tmp/recipe-$serial.html";
        }
    }
}

my $i = 1;
await start for @recipes -> $r {
# for @recipes -> $r {
    my $description = "Categories: " ~ $r.categories().join( " - ");
    my $title;
    if $r.title ~~ Str {
        $title = $r.title
    } else {
        $title = $r.title.decode
    }
    my $recipe = Raku::Recipes::Recipe.new(
        :$title,
        :$description,
        ingredients => $r.ingredients().map: {.product }
            );
    $queue.send: ($i++, $recipe);
}

$queue.close;

await @promises;

sub template-file( $template-file-name ) {
    "resources/$template-file-name".IO.e
            ??"resources/$template-file-name".IO.slurp
            !!%?RESOURCES{$template-file-name}.slurp;
}