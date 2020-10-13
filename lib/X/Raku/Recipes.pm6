use Raku::Recipes::Roly;

class X::Raku::Recipes::WrongType:api<1> is Exception {
    has $.desired-type is required;
    has $.product;
    has $.actual-types;

    submethod BUILD(:$!desired-type,
                    :$!product = "Object") {
        my $rrr = Raku::Recipes::Roly.new();
        if $!product ne "Object" {
            $!actual-types = $rrr.calories-table{$!product}<types>
        }
    }

    multi method message( X::Raku::Recipes::WrongType $x where $x.product eq
            "Object": ) {
        return "The product is not of the required type $!desired-type";
    }

    multi method message() {
	    return "$!product is not of the required type «$!desired-type», only types $!actual-types";
    }
}

class X::Raku::Recipes::WrongUnit:api<1> is Exception {
    has $!desired-unit is required;
    has $!unit;

    submethod BUILD(:$!desired-unit,
                    :$!unit) {}

    method message() {
        return "$!unit does not match the unit type, should be $!desired-unit";
    }
}