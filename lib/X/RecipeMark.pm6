use Grammar::Message;

unit module X::RecipeMark;

role Base is Exception {
    has Match $.match;
    submethod BUILD( :$!match ) {}
}

class OutOfOrder does Base {
    has $.number;
    has $.last;

    submethod BUILD( :$!match, :$!number, :$!last ) {}

    multi method message () {
        pretty-message(
                "Found instruction number $!number while waiting for number > $!last",
                $!match  );
    }
}

class RepeatedIngredient does Base {
    has $.name;

    submethod BUILD( :$!match, :$!name ) {}

    multi method message () {
        pretty-message("Ingredient $!name appears twice",
        $!match );
    }

}