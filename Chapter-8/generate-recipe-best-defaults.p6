#!/usr/bin/env raku

use Raku::Recipes::Roly;
use X::Raku::Recipes;
use X::Raku::Recipes::Missing;

my $rrr = Raku::Recipes::Roly.new();
my $main = @*ARGS[0] // "Chickpeas";
my $side = @*ARGS[1] // "Rice";
my $calories;

try {
    $calories = $rrr.calories-for( main => $main => 200,
                                   side => $side => 250 );
    CATCH {
       when X::Raku::Recipes::Missing::Product {
            given .message {
                when /$main/ { $main = "Pasta" }
                when /$side/ { $side = "Potatoes" }
            }
            proceed;
       }
       when X::Raku::Recipes::WrongType {
            given .message {
                when /Main/ { $main = "Chickpeas" }
                when /Side/ { $side = "Rice" }
            }
            proceed;
       }
       when none(X::Raku::Recipes::Missing::Product,
                X::Raku::Recipes::WrongType) {
           die "There's something wrong with ingredients, I can't generate
that";
       }
       default {
            $calories = $rrr.calories-for( main => $main => 200,
                    side => $side => 250 );
       }

    }
}

say "Calories for a main dish of $main and side of $side are $calories";