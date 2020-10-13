use Raku::Recipes::Grammarole::Measured-Ingredients;
use Grammar::PrettyErrors;
use Grammar::Common::Text;
use X::RecipeMark;

unit grammar RecipeMark::Grammar
        does Raku::Recipes::Grammarole::Measured-Ingredients
        does Grammar::PrettyErrors
        does Grammar::Common::Text;

token TOP {
    "#" \h+ <title>
    <.separation>
    <description>
    <.separation>
    "##" \h+ Ingredients \h+ "(for" \h+ $<persons> = \d+ \h+ person s? ")"
    <.separation>
    <ingredient-list>
    <.separation>
    "##" \h+ Preparation \h+ "(" $<time> = \d+ "m)"
    <.separation>
    <instruction-list>
}

token separation { <ws> ** 2 }

token title { <words>+ % \h }

token description { [<.sentence> | <.sentence>+ % \s+] }

token ingredient-list {
    :my $*INGREDIENTS = ∅;
    <itemized-ingredient>+ % \v }

token itemized-ingredient {
    ["*"|"-"] \h+ <ingredient-description>
    {
        my $product = tc ~$/<ingredient-description><measured-ingredient
><product>;
        if $product ∉ $*INGREDIENTS {
            $*INGREDIENTS ∪= $product;
        } else {
            X::RecipeMark::RepeatedIngredient.new( :match($/),
                    :name($product) ).throw;
        }
    }
}

token instruction-list {
    :my UInt $*LAST = 0;
    <numbered-instruction>+  % \v
}

token numbered-instruction {
    <numbering> \h+ <instruction>
}

token instruction { <action-verb> \h <sub-sentence> <.stop>}

token numbering {
    \d+ )> "." {
        if +$/ < $*LAST {
            X::RecipeMark::OutOfOrder.new( :match($/),
            :number(+$/),
            :last($*LAST) ).throw;
        } else {
            $*LAST = +$/;
        }
    }
}

token action-verb { <.words>  }

token ws { <!ww> \v }