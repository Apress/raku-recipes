#!/usr/bin/env raku

use Raku::Recipes::Calorie-Computer;
use X::Raku::Recipes;

my $rrr = Raku::Recipes::Calorie-Computer.new();
my $main = @*ARGS[0] // "Chickpeas";
my $side = @*ARGS[1] // "Rice";

my $calories = $rrr.calories-for( main => $main => 200,
                                  side => $side => 250 );

say "Calories for a main dish of $main and side of $side are $calories";

CATCH {
    default {
        given .message {
            when /Main/ || /$main/ { $main = "Chickpeas" }
            when /Side/ || /$side/ { $side = "Rice" }
        }
        $calories = $rrr.calories-for( main => $main => 200,
                side => $side => 250 );
        .resume;
    }
}