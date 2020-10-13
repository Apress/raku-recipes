#!/usr/bin/env perl6

use Inline::Perl5;
use MealMaster:from<Perl5>;

my $input-file-name = @*ARGS[0] // "allrecip.mmf";

my $all-recipes = $input-file-name.IO.slurp;

my @recipes = $all-recipes.split( /^^ ["-----" | "MMMMM"] \s+ /);
my $index = 1;

for @recipes.rotor(400) -> @chunk {
    my $all-recipes = '';
    for @chunk -> $r {
        my $this-mm;
        if $r ~~ /^"-"/ {
            $this-mm = "$r\n-----\n";
        } else {
            $this-mm = "$r\nMMMMM\n";
        }

        "/tmp/temp.mmf".IO.spurt($this-mm);
        if MealMaster.parse("/tmp/temp.mmf") {
            $all-recipes = "$all-recipes$this-mm\n";
        } else {
            say $all-recipes;
            die $this-mm;
        }
    }
    "/tmp/all-recipes-$index.mmf".IO.spurt( $all-recipes );
    $index++;
}