#!/usr/bin/env perl6

use Wikidata::API;
use X::Wikidata::API;
use Raku::Recipes::SQLator;

my $dator = Raku::Recipes::SQLator.new;

for $dator.get-ingredients.keys.rotor(4) -> @fragment {
    my @promises = do for @fragment -> $ingredient is copy {
        start {
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
            say $result.raku;
            if $result<results><bindings> -> @r {
                @r.first<itemDescription><value>;
            } else {
                warn "No result found"
            }

            CATCH {
                when X::Wikidata::API { warn $_.message }
                default { warn "Inespecific error ", $_.message }
            }
        }
    }

    my @results = await @promises;

    .say for @results;

}
