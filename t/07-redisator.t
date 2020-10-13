use Test;

use lib <lib t/lib>;

use Raku::Recipes::Redisator;
use X::Raku::Recipes::Missing;
use RecipesTestHelp;

my $redisator = Raku::Recipes::Redisator.new();
isa-ok( $redisator, Raku::Recipes::Redisator, "Correct class");

my %new-ingredient = Calories => "85",
                     Unit => "Unit",
                     Protein => "1.1",
                     Vegan => "Yes",
                     Dairy => "No",
                     Dessert => "Yes",
                     Main => "No",
                     Side => "Yes";

my %data = test-insert-retrieve( $redisator, "Banana", %new-ingredient);
is( %data<Unit>, "Unit", "Correct hash");
is $redisator<Banana><Unit>, "Unit", "Adds correctly stuff";
is( $redisator<Banana>, %data, "Associative works");

%new-ingredient = Calories => "163",
                  Unit => "226g",
                  Protein => "28",
                  Vegan => "No",
                  Dairy => "Yes",
                  Dessert => "Yes",
                  Main => "No",
                  Side => "Yes";

%data = test-insert-retrieve( $redisator, "Cottage cheese", %new-ingredient);

my %ingredients = $redisator.get-ingredients();
is( %ingredients<Banana><Unit>, "Unit", "Correct hash from all retrieved");

my @vegan = $redisator.search-ingredients({ Vegan => "Yes" });
ok(@vegan, "Searching works");
cmp-ok(@vegan.elems, ">=", 1, "Elements are OK");
nok($redisator.search-ingredients({ :Vegan("Yes"), :Dairy("Yes") }),
        "No vegan and dairy");
my @vegan'n'dessert =
        $redisator.search-ingredients({ :Vegan("Yes"), :Dessert("Yes") });
cmp-ok(@vegan'n'dessert, "⊆", @vegan, "Vegan desserts are vegan");


lives-ok { $redisator.delete-ingredient( "Banana") },
        "Can delete ingredient";

nok( $redisator<Banana>, "Ingredient deleted");


done-testing;
