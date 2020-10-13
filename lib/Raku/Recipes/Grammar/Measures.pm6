use Raku::Recipes;

unit role Raku::Recipes::Grammar::Measures;

token quantity { <:N>+ }
token unit     { @unit-types }
