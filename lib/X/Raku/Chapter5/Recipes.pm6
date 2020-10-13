use Raku::Recipes;
use Colorizable;

class X::Raku::Recipes::Obsolete is Exception {
    has $!old-stuff is required;
    has $!new-stuff is required;

    submethod BUILD( :$!old-stuff, :$!new-stuff){}

    method message() {
        return "You seem to be using $!old-stuff, which is deprecated. Please switch to $!new-stuff";
    }

    multi method gist(X::Raku::Recipes::Obsolete:D: ) {
        say self.backtrace.list.raku;
        my @nice-bts = self.backtrace.list.grep( ! *.is-setting() );
        @nice-bts.shift;
        my $output =  ("Hey! " but Colorizable).colorize: :mo(bold);
        $output ~= ( self.message but Colorizable).colorize: :mo(underline);
        $output ~= "\nThis happened on ⇒\n";
        for @nice-bts -> $bt {
            $output ~= (("\t» Line " ~ $bt.line()) but Colorizable).colorize:
                    blue;
            my $subname = ($bt.subname eq "<unit>")??  "an anonymous routine"!!
                                        $bt.subname;
            $output ~= " in " ~ ($subname but Colorizable).colorize: cyan;
        }
        return $output;
    }

}

class X::Raku::Recipes::WrongType:api<0> {

    submethod BUILD() {
        X::Raku::Recipes::Obsolete.new(
            old-stuff => "X::Raku::Recipes::WrongType:api<0>",
            new-stuff => "X::Raku::Recipes::WrongType:api<1> in
Raku::Recipes"
        ).throw;
    }
}



class X::Raku::Recipes::ProductMissing:api<0> is Exception {
    has $!product is required;

    submethod BUILD( :$!product) {}

    method message() {
	    return "We don't seem to have information about  $!product";
    }
}

class X::Raku::Recipes::MissingPart:api<0> is Exception {
    has $!part is required;

    submethod BUILD( :$!part ) {}

    method message() {
        return "An essential part of the meal is missing:  $!part";
    }
}
