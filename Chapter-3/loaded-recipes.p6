#!/usr/bin/env raku

my $ingredients = ( rice => 1, chickpeas => 1,
                    onion => 2, tomatoes => 1,
                    garlic => 0.5, pasta => 1,
                    chestnut => 0.25, bellpeppers => 1).Mix;


for ^10 {
    say "New recipe ⇒ ", $ingredients.roll( 5 ).unique.join(", ");
}
