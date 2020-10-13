unit grammar Raku::Recipes::Grammar::Ingredients;

token TOP     { <row> }
token row     {  ["*" || "-" || "✅"]  \h+ <ingredient> }
token ingredient      { <quantity> \h* <unit>? }
token quantity { <:N>+ }
token unit     { "g" | "tbsp" | "clove" | "tbsps" | "cloves" }