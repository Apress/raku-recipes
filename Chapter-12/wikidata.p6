#!/usr/bin/env perl6

use Wikidata::API;
use Raku::Recipes::SQLator;

my $dator = Raku::Recipes::SQLator.new;

for $dator.get-ingredients.keys -> $ingredient is copy {

    $ingredient = lc $ingredient;
    my $query = qq:to/END/;
SELECT distinct ?item ?itemLabel ?itemDescription WHERE\{
  ?item ?label "$ingredient"\@en.
  ?item wdt:P31?/wdt:P279* wd:Q25403900.
  ?article schema:about ?item .
  ?article schema:inLanguage "en" .
  ?article schema:isPartOf <https://en.wikipedia.org/>.
  SERVICE wikibase:label \{ bd:serviceParam wikibase:language "en". \}
\}
END

    my $result = query($query);
    if $result<results><bindings> -> @r {
        say "$ingredient ⇒\n\t", @r.first<itemDescription><value>;
    }
}

sub utf8y ( $str ) {
    Buf.new( $str.ords ).decode("utf8")
}