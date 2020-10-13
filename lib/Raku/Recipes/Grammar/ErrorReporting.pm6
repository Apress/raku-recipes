unit grammar Raku::Recipes::Grammar::ErrorReporting;

token TOP     { <row> }
token row     {  <.dingbat> <.whitespace> <ingredient> }
token dingbat    {  ["*" || "-" || "✅"]  }
token whitespace { \h+ }
token ingredient      { <quantity> \h* <unit>? }
token quantity { <:N>+ }
token unit     { "g" | "tbsp" | "clove" | "tbsps" | "cloves" }