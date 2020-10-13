=begin pod

=head1 NAME

Raku::Recipes::SQLator - Uses SQLite or other relational database to store and
retrieve data

=head1 SYNOPSIS

=begin code
use Raku::Recipes::SQLator;

=end code

=head1 DESCRIPTION

Use a database driver to get to data, with basic CRUD operations.

=end pod

use DBIish;
use Raku::Recipes::Dator;
use Raku::Recipes;
use X::Raku::Recipes::Missing;

#| Basic calorie table handling role
unit class Raku::Recipes::SQLator does Raku::Recipes::Dator does Associative;

#| Contains the table of calories
has $!dbh;
has @!columns;

#|[
Connects to the database
]
method new( $file = "Chapter-12/ingredients.sqlite3" ) {
    my $dbh = DBIish.connect("SQLite", :database($file));
    # This is SQLITE3 specific
    my $sth = $dbh.prepare("PRAGMA table_info('recipedata');");
    $sth.execute;
    my @table-data = $sth.allrows();
    my @columns = @table-data.map: *[1].tc;
    self.bless( :$dbh, :@columns );
}

submethod BUILD( :$!dbh, :@!columns ) {}

#| Retrieves a single ingredient by name
method get-ingredient( Str $ingredient ) {
    my $sth = self!run-statement(q:to/GET/,$ingredient);
SELECT * FROM recipedata where name = ?;
GET
    with $sth.allrows()[0] { return self!hashify($_) }
    else { return []};
}

#| To make it work as Associative.
multi method AT-KEY( Str $ingredient ) {
    return self.get-ingredient( $ingredient );
}

#| Hashifies a row to make it an uniform format
method !hashify( @row is copy ) {
    my %hash;
    for @!columns -> $c {
        %hash{$c} = shift @row
    }
    %hash<name>:delete;
    return %hash;
}

#| Prepare and execute in a single sub
method !run-statement( $stmt, *@args ) {
    my $sth = $!dbh.prepare($stmt);
    $sth.execute(@args);
    return $sth;
}

#| Retrieves all ingredients in a hash
method get-ingredients {
    my $sth = $!dbh.prepare(q:to/GET/);
SELECT * FROM recipedata;
GET
    $sth.execute;
    my %rows;
    for $sth.allrows() -> @row {
        my $name = @row[0];
        my %this-hash = self!hashify(@row);
        %rows{$name} = %this-hash;
    }
    return %rows;
}

#| Search ingredients by criteria
method search-ingredients( %search-criteria ) {
    my @clauses = do for %search-criteria.kv -> $k,$v {
        lc($k) ~ " = '" ~ $v ~ "'";
    }
    my $query = "SELECT name FROM recipedata WHERE " ~ @clauses.join( " AND ");
    $query ~~ s:g/<|w>True<|w>/Yes/;
    $query ~~ s:g/<|w>False<|w>/No/;
    my $sth = $!dbh.prepare($query);
    $sth.execute;
    return $sth.allrows().map: *[0];
}

#| Insert a new ingredient
method insert-ingredient( Str $ingredient, %data ) {
    my $stmt = "INSERT INTO recipedata (" ~ @!columns.join(", ")
        ~ ") VALUES (" ~ ("?" xx @!columns.elems ).join(", ") ~ ")";
    my @values = $ingredient;
    for @!columns[1..*] -> $c {
        with %data{$c} { @values.push: %data{$c} }
        else { X::Raku::Recipes::Missing::Column.new( :name($c) ).throw }
    }
    my $sth = $!dbh.prepare($stmt);
    $sth.execute( |@values);
}

#| Deletes an ingredient by name
method delete-ingredient( Str $ingredient) {
    my $sth = $!dbh.prepare(q:to/DELETE/);
delete FROM recipedata where name = ?
DELETE
    $sth.execute( $ingredient);
}