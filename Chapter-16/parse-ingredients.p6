#!/usr/bin/env perl6

use Raku::Recipes::Grammarole::Measured-Ingredients;
grammar Tester does Raku::Recipes::Grammarole::Measured-Ingredients {}

say Tester.subparse("½ onion",
        rule => "ingredient-description")<measured-ingredient>;

say Tester.subparse("⅓ liter wine (or beer)",
        rule => "ingredient-description");

say Tester.subparse("3 eggs (free run)",
        rule => "ingredient-description");