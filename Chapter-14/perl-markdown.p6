#!/usr/bin/env perl6

use Inline::Perl5;

use MealMaster:from<Perl5>;
use Text::Markdown:from<Perl5>;

use Raku::Recipes::Recipe;

my $parser = MealMaster.new();
my @recipes = $parser.parse("Chapter-14/apetizer.mmf");

my $md = Text::Markdown.new();

for @recipes -> $r {
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
    say $md.markdown( $recipe.gist );
}
