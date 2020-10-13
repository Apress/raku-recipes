#!/usr/bin/env raku

my Blob $image = slurp( @*ARGS[0] // "../recipes-images/rice.jpg", :bin);

# From here https://stackoverflow.com/a/43313299/891440 by user6096479
my $index = 0;
until $image[$index] == 255 and $image[$index+1] == any( 0xC0, 0xC2 ) {
    $index++;
    last if $index > $image.elems;
}

if ( $index < $image.elems ) {
   say "Height ", $image[$index+5]*256 + $image[$index+6];
   say "Width ", $image[$index+7]*256 + $image[$index+8];
} else {
    die "JPG metadata not found, damaged file or wrong file format";
}
    

