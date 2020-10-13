use Raku::Recipes::CSVDator;
use Raku::Recipes::Grammar::Measures;

my @products = Raku::Recipes::CSVDator.new.products;

unit role Raku::Recipes::Grammarole::Measured-Ingredients does
    Raku::Recipes::Grammar::Measures;

token ingredient-description {
    <measured-ingredient> \h* <options>?
}

token measured-ingredient {
    [ <quantity> \h* <unit> \h+ <product> || <quantity> \h+ <product>] s?
}

token options {
    '(' ~ ')' $<content> = .+?
}

token product {:i @products }