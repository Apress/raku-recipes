use Test;
use lib <lib t/lib>;

use RecipesTestHelp;
use Raku::Recipes::SQLator;
use X::Raku::Recipes::Missing;

# This needs the database to have been already created

my $filename = "Chapter-12/ingredients.sqlite3".IO.e
    ??"Chapter-12/ingredients.sqlite3"
        !!"ingredients.sqlite3";

my $sqlator = Raku::Recipes::SQLator.new($filename);

isa-ok( $sqlator, Raku::Recipes::SQLator, "Correct class");
my %data = $sqlator.get-ingredient("Rice");
ok( %data, "Retrieves ingredient");
is( %data<Unit>, "100g", "Correct hash");

is( $sqlator<Rice>, %data, "Associative works");

my %ingredients = $sqlator.get-ingredients();
is( %ingredients<Lentils><Unit>, "100g", "Correct hash");

my @vegan = $sqlator.search-ingredients({ Vegan => True });
ok(@vegan, "Searching works");
cmp-ok(@vegan.elems, ">=", 14, "Elements are OK");
nok($sqlator.search-ingredients({ :Vegan, :Dairy }), "No vegan and dairy");
my @vegan'n'dessert = $sqlator.search-ingredients({ :Vegan, :Dessert });
cmp-ok(@vegan'n'dessert, "⊂", @vegan, "Vegan desserts are vegan");

my %new-ingredient = Calories => "85",
                       Unit => "Unit",
                       Protein => "1.1",
                       Vegan => "Yes",
                       Dairy => "No",
                       Dessert => "Yes",
                       Main => "No",
                       Side => "Yes";

lives-ok { $sqlator.insert-ingredient( "Banana", %new-ingredient) },
        "Can insert ingredient";

is $sqlator<Banana><Unit>, "Unit", "Adds correctly stuff";

lives-ok { $sqlator.delete-ingredient( "Banana") },
        "Can delete ingredient";

nok( $sqlator<Banana>, "Ingredient deleted");


done-testing;
