use Raku::Recipes::Roly;
use Raku::Recipes::Grammar::Measures;

my @products;
BEGIN {
    @products = Raku::Recipes::Roly.new.products;
}

unit grammar Raku::Recipes::Grammar::Measured-Ingredients does Raku::Recipes::Grammar::Measures;
token TOP {
    [ <quantity> \h* <unit> \h+ <ingredient> || <quantity> \h+ <ingredient>]
    \h* ['(' ~ ')' .+? ] ?
}

token ingredient {:i @products "s"? }