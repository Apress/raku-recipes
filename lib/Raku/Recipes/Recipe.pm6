use Raku::Recipes::Ingredients;

#| A class with a fragment of a recipe: description + ingredients
unit class Raku::Recipes::Recipe does Raku::Recipes::Ingredients;

has Str $.title;
has Str $.description;

method gist {
    return "# $!title\n\n$!description\n\n## Ingredients\n\n"
        ~ self.Raku::Recipes::Ingredients::gist;
}
