#!/usr/bin/env perl6

use MongoDB::Client;
use MongoDB::Database;
use BSON::Document;

my MongoDB::Client $client .= new(:uri('mongodb://'));
my MongoDB::Database $database = $client.database('recipes');
my MongoDB::Collection $recipes = $database.collection('recipes');

my $regex = BSON::Regex.new( regex => @*ARGS[0]) ;
my MongoDB::Cursor $cursor =
        $recipes.find( criteria => ["title" => '$regex' => $regex],
                        projection => [ "title" => 1] );

while $cursor.fetch -> BSON::Document $d {
    say $d<title>;
}