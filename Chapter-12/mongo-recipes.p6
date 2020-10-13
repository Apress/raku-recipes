#!/usr/bin/env perl6

use MongoDB::Client;
use MongoDB::Database;
use BSON::Document;
use Raku::Recipes::Texts;

my $recipes-text = Raku::Recipes::Texts.new();

my MongoDB::Client $client .= new(:uri('mongodb://'));
my MongoDB::Database $database = $client.database('recipes');

my @documents;
for $recipes-text.recipes.kv -> $title, %data {
    %data<title> = $title;
    if %data<ingredients>.elems > 1 {
        for %data<ingredients>.kv -> $k, $v {
            %data{"ingredient-list-$k"} = $v.trim;
        }
    }
    %data<ingredients>:delete;
    @documents.append: BSON::Document.new((|%data)),
}

say "Inserting docs";
my BSON::Document $req .= new: (
insert => 'recipes',
documents => @documents
);
my BSON::Document $doc = $database.run-command($req);
if $doc<ok> {
    say "Docs inserted";
}