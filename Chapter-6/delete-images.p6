#!/usr/bin/env raku

use Docker::API;

my Docker::API $docker-api .= new;

my @images = $docker-api.images( dangling => True )[];

for @images -> %i {
    say "Trying to delete %i<Id>";
    $docker-api.image-remove( name => %i<Id> );
    CATCH {
	default {
	    if .message ~~ /"being used"/ {
		say "Image %i<Id> not deleted, since it's being used";
	    }
	}
    }
}
