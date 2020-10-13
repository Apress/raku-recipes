use Raku::Recipes::Classy;

say Raku::Recipes::Classy.WHY;
say Raku::Recipes::Classy.^lookup('filter-ingredients').WHY;
say Raku::Recipes::Classy.^lookup('filter-ingredients').^name;
say Raku::Recipes::Classy.new.^lookup('filter-ingredients').HOW;
say Raku::Recipes::Classy.^lookup('optimal-ingredients').WHY;


