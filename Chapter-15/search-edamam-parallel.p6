#!/usr/bin/env perl6

use Cro::HTTP::Client;
use URI::Encode;
use Raku::Recipes::SQLator;

my $appID = %*ENV{'EDAMAM_APP_ID'};
my $api-key = %*ENV{'EDAMAM_API_KEY'};
my $api-req = "\&app_id=$appID\&app_key=$api-key";

my $dator = Raku::Recipes::SQLator.new;
my $cro = Cro::HTTP::Client.new(base-uri => "https://api.edamam.com/");

my @responses = do for $dator.get-ingredients.keys[^5] -> $ingredient {
    $cro.get("search?q=" ~ uri_encode(lc($ingredient)) ~ $api-req) ;
}

for await @responses -> $response {
    my %data = await $response.body;
    say "⇒Ingredient %data<q>\n\t→", %data<hits>.map(*<recipe><label>).join:
            "\n\t→";

}


