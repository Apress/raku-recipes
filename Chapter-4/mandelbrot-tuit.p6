#!/usr/bin/env raku

use Array::Shaped::Console;

sub mandelbrot( Complex $c --> Seq ) {
    0, *²+$c ... *.abs > 2;
}

my $min-x = -4;
my $max-x = 4;
my $min-y = -5;
my $max-y = 2;
my $scale = 1/4;
my $limit = 100;
my @mandelbrot[$max-y - $min-y + 1; $max-x - $min-x + 1];
for $min-y..$max-y X $min-x..$max-x -> ( $re, $im ) {
    my $mandel-seq := mandelbrot( Complex.new( $re*$scale, $im*$scale) );
    @mandelbrot[$re-$min-y;$im-$min-x] = $mandel-seq[$limit].defined??
          ∞ !! $mandel-seq.elems;
}
say printed(@mandelbrot,@shades);

