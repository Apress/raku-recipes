use Raku::Recipes::Grammar::RecipeMark;
use Raku::Recipes::Grammar::RecipeMark::Actions;

unit class RecipeMark::Recipe;

has Str $.title;
has Str $.description;
has UInt $.persons;
has UInt $.preparation-minutes;
has %.ingredient-list;
has @.instruction-list;

