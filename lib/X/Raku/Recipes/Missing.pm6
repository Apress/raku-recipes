role X::Raku::Recipes::Missing:api<1> is Exception {
    has $!part is required;
    has $!name is required;

    submethod BUILD( :$!part, :$!name ) {}

    method message() {
        return "the $!part $!name seems to be missing. Please provide it";
    }

    method gist(X::Raku::Recipes::Missing:D: ) {
        self.message()
    }

}

class X::Raku::Recipes::Missing::Part does X::Raku::Recipes::Missing {
    submethod BUILD( :$!part="part of meal", :$!name) {}

}

class X::Raku::Recipes::Missing::File does X::Raku::Recipes::Missing {
    submethod BUILD($!part = "file", :$!name){}

}


class X::Raku::Recipes::Missing::Product does X::Raku::Recipes::Missing {
    submethod BUILD($!part = "product", :$!name){}

}

class X::Raku::Recipes::Missing::Column does X::Raku::Recipes::Missing {
    submethod BUILD($!part = "column", :$!name){}
}