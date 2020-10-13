#!/usr/bin/env perl6

use v6;

class Recipes {
    has $.folder;
    has $.folder-path= IO::Path.new( $!folder );
    has $!is-win = $*DISTRO.is-win;

    multi method show( $self where .is-win: ) {
        shell "dir {$self.folder-path}";
    }

    multi method show( $self: ) {
         shell "ls {$self.folder-path}";
    }
}

Recipes.new(folder => "recipes/desserts").show
