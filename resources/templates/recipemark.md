# <%= $recipemark.title %>

<%= $recipemark.description %>

## Ingredients (for <%= $recipemark.persons %> persons)

<%
use URI::Encode;
my %ingredients = $recipemark.ingredient-list;
for %ingredients.kv -> $product, %data {
    take "* %data<quantity> %data<unit> "
        ~ "[ {lc $product} ](/Ingredient/" ~ uri_encode($product) ~ ")"
                    ~ (" %data<options>" if %data<options> ) ~ "\n";   
} %>

## Preparation (<%= $recipemark.preparation-minutes %>m)

<% 
for $recipemark.instruction-list[0][] -> $instruction {
    take $instruction.key ~ ". " ~ "*" ~ $instruction.value.key ~ "* "
            ~ $instruction.value.value ~ "\n";
}
%>
