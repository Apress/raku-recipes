#| Role that describes generic recipe ingredients
unit role Raku::Recipes::Ingredients;

has @.ingredients;

method how-many { return @!ingredients.elems }
method gist { return @!ingredients.map( "* " ~ * ~ "\n").join }
