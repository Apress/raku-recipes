use Test;

use Red:api<2>;
use Raku::Recipes::IngRedient;

my $*RED-DB = database "SQLite";
Raku::Recipes::IngRedient.^create-table;

my %new-ingredient =
            name => "Banana",
            calories => 85,
            unit => "Unit",
            protein => 1.1,
            :vegan,
            :!dairy,
            :dessert,
            :!main,
            :side;

my $ingredient = Raku::Recipes::IngRedient.^create: |%new-ingredient;

is( $ingredient.name, "Banana", "Assigned name OK");

my $back-ingredient = Raku::Recipes::IngRedient.^load: :name("Banana");

is( %new-ingredient<name>, $back-ingredient.name, "Reconstructs ingredient");

done-testing;
