use Test;
use lib <lib t/lib>;

use RecipesTestHelp;
use Raku::Recipes::CSVDator;
use X::Raku::Recipes::Missing;

my $rr = Raku::Recipes::CSVDator.new( "." );
test-dator( $rr );
done-testing;
