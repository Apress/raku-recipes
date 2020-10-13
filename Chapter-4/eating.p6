#!/usr/bin/env raku

use Math::Matrix;

# Recipe x ingredient
# Columns = Recipes
# Rows = Amount of rice, chickpeas and tomato
my $food-matrix = Math::Matrix.new( [[ 150, 50, 50 ],
				    [ 50, 150, 50 ],
				    [ 100, 150, 100 ]] );

# Columns = People
# Rows = percentage of dish eaten
my $person-recipes = Math::Matrix.new( [[ 0.5, 0.8, 0.3 ],
				       [ 0.9, 1, 1 ],
				       [ 0.2, 0.8, 0.7 ]] );

say $food-matrix dot $person-recipes;

