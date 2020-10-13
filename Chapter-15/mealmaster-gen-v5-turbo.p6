#!/usr/bin/env perl6

use Inline::Perl5;

use MealMaster:from<Perl5>;

use Raku::Recipes::Recipe;
use Raku::Recipes::SQLator;
use Recipr::Log::Timeline;

use URI::Encode;
use Template::Classic;
use cmark::Simple;

my $threads = @*ARGS[0] // 3;
my Channel $queue .= new;

my $parser = MealMaster.new();
my @recipes = $parser.parse("Chapter-15/allrecip.mmf");

my %ingredients = Raku::Recipes::SQLator.new.get-ingredients;
my @known = %ingredients.keys.map: *.lc;

my &generate-page = template :($title,$content),
        template-file( "templates/recipe-with-title.html" );

my %urls-for-known = | @known.map: { $_ => "[$_](/ingredient/$_)"};

my @promises = do for ^$threads {
    start react whenever $queue -> $recipe-file  {
        Recipr::Log::Timeline::Processing.log: -> {
            $recipe-file.path ~~ /$<serial> = (\d+)/;
            my $serial = +$<serial>;
            my @all-lines = $recipe-file.lines;
            my $recipes = @all-lines
                    .grep({ !$_.starts-with("MMMMM") })
                    .grep({ !$_.starts-with("-----") })
                    .join("\n");
            $recipes ~~ s:g/\h+ "Title:" /# /;
            for <Categories Yield> -> $c {
                $recipes ~~ s:g/\h+$c/## $c/;
            }
            process-recipes($serial, $recipes);
        }
    }
}

await start for dir("/tmp", test => /"all-recipes"/ ) -> $r-file {
    $queue.send: $r-file;
}

$queue.close;
await @promises;

# Subs
sub template-file( $template-file-name ) {
    "resources/$template-file-name".IO.e
            ??"resources/$template-file-name".IO.slurp
            !!%?RESOURCES{$template-file-name}.slurp;
}
sub process-recipes( $serial, $recipe ) {
    "/tmp/recipes-$serial.html".IO.spurt(generate-page("Recipes $serial",
            commonmark-to-html($recipe)).eager.join);
    say "Writing /tmp/recipes-$serial.html";

}