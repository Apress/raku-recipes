use RecipeMark::Grammar;
use RecipeMark::Grammar::Actions;

use Raku::Recipes::CSVDator;

use JSON::Fast;

unit class RecipeMark;
has Str $.title;
has Str $.description;
has UInt $.persons;
has UInt $.preparation-minutes;
has %.ingredient-list;
has @.instruction-list;

method new( $file where .IO.e) {
    my %temp = RecipeMark::Grammar.parse(
            $file.IO.slurp,
            actions => RecipeMark::Grammar::Actions.new
            ).made;
    self.bless(| %temp );
}

method to-json() {
    return to-json self.Hash ;
}

method Hash() {
    return { title => $!title,
             description => $!description,
             persons => $!persons,
             preparation-minutes => $!preparation-minutes,
             ingredient-list => %!ingredient-list,
             instruction-list => @!instruction-list
    }
}

method product-list() {
    return %!ingredient-list.keys;
}

method vegan() {
    my $data = Raku::Recipes::CSVDator.new;
    return so all self.product-list.map:
            { $data.get-ingredient($_)<Vegan> };
}