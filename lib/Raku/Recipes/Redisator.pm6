=begin pod

=head1 NAME

Raku::Recipes::Redisator - Uses Redis to store and
retrieve data

=head1 SYNOPSIS

=begin code
use Raku::Recipes::Redisator;

=end code

=head1 DESCRIPTION

Use a Redis driver to get to data, with basic CRUD operations.

=end pod

use Redis;
use Raku::Recipes::Dator;
use Raku::Recipes;
use X::Raku::Recipes::Missing;

#| Basic calorie table handling role
unit class Raku::Recipes::Redisator does Raku::Recipes::Dator does Associative;

#| Contains the table of calories
has $!redis;

#|[
Connects to the database
]
method new( $url = "127.0.0.1:6379" ) {
    my $redis = Redis.new($url, :decode_response);
    self.bless( :$redis );
}

submethod BUILD( :$!redis ) {}

#| Retrieves a single ingredient by name
method get-ingredient( Str $ingredient ) {
    $!redis.hgetall( "recipes:$ingredient");
}

#| To make it work as Associative.
multi method AT-KEY( Str $ingredient ) {
    return self.get-ingredient( $ingredient );
}

#| Retrieves all ingredients in a hash keyed by name
method get-ingredients {
    my @keys = $!redis.keys("recipes:*");
    my %rows;
    for @keys.first<> -> $k {
        $k ~~ /<?after "recipes:">$<key>=(.+)/;
        %rows{~$<key>} = $!redis.hgetall("recipes:" ~ $<key>)
    }
    return %rows;
}

#| Search ingredients by key values
method search-ingredients( %search-criteria ) {
    my %ingredients = self.get-ingredients;
    %ingredients.keys.grep:
            { search-table(  %ingredients{$_},%search-criteria) };
}

#| Insert a new ingredient
method insert-ingredient( Str $ingredient, %data ) {
    $!redis.hmset("recipes:$ingredient", |%data);
}

#| Deletes an ingredient by name
method delete-ingredient( Str $ingredient) {
   $!redis.del("recipes:$ingredient")
}