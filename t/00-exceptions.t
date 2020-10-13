use Test; # -*- mode: perl6 -*-
use Raku::Recipes::Roly;
use X::Raku::Recipes;
use X::Raku::Recipes::Missing;

my $x =  X::Raku::Recipes::WrongType.new( desired-type => "Main" );
isa-ok $x, X::Raku::Recipes::WrongType, "Type OK";
throws-like { $x.throw },  X::Raku::Recipes::WrongType, message => /Main/,  "Throws OK";
is $x.product, "Object", "Assigns default type";

$x =  X::Raku::Recipes::WrongType.new( desired-type => "Main",
        product => "Apple");
is $x.product, "Apple", "Assigns real type";
is $x.actual-types.elems, 2, "Checks actual types";

$x =  X::Raku::Recipes::Missing::File.new( name => "calories-table.csv" );
isa-ok $x, X::Raku::Recipes::Missing::File, "Type OK";
throws-like { $x.throw },  X::Raku::Recipes::Missing::File, message =>
        /calories/,
        "Throws OK";

$x =  X::Raku::Recipes::Missing::Part.new( name => "main" );
isa-ok $x, X::Raku::Recipes::Missing::Part, "Type OK";
throws-like { $x.throw },  X::Raku::Recipes::Missing::Part, message =>
        /main/,
        "Throws OK";

throws-like { $x.throw },  X::Raku::Recipes::Missing::Part,
        message => /it$$/,
        "Throws without backtrace";

$x =  X::Raku::Recipes::Missing::Product.new( name => "cardboard" );
isa-ok $x, X::Raku::Recipes::Missing::Product, "Type OK";
throws-like { $x.throw },  X::Raku::Recipes::Missing::Product,
        message => /cardboard/,
        "Throws OK";

throws-like { my $will-blow = Raku::Recipes::Roly.new("does-not-exist.csv") },
    X::Raku::Recipes::Missing::File, message => /"not-exist"/,
        "Checks unexistent file";

done-testing;
