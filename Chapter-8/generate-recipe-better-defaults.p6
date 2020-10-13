#!/usr/bin/env raku

use Raku::Recipes::Calorie-Computer;
use X::Raku::Recipes;
use X::Raku::Recipes::Missing;

my $cc = Raku::Recipes::Calorie-Computer.new();
my $main = @*ARGS[0] // "Chickpeas";
my $side = @*ARGS[1] // "Rice";
my $calories;

{
    $calories = $cc.calories-for(main => $main => 200,
            side => $side => 250);
    CATCH {
        when X::Raku::Recipes::Missing::Product {
            given .message {
                when /$main/ { $main = "Pasta" }
                when /$side/ { $side = "Potatoes" }
            }
            $calories = $cc.calories-for(main => $main => 200,
                    side => $side => 250);
        }
        when X::Raku::Recipes::WrongType {
            given .desired-type {
                when "Main" { $main = "Chickpeas" }
                when "Side" { $side = "Rice" }
            }
            $calories = $cc.calories-for(main => $main => 200,
                    side => $side => 250);
        }

    }

}
say "Calories for a main dish of $main and side of $side are $calories";
