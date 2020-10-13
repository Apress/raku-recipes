#!/usr/bin/env perl6

use Cro::HTTP::Client;

my $ingredient = @*ARGS[0] // "water";
my $cro = Cro::HTTP::Client.new(base-uri => "http://localhost:31415/Ingredient/" );
my $response = await $cro.get( $ingredient );
say  await $response.body;

