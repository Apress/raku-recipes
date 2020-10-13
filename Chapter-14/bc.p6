#!/usr/bin/env perl6

sub term:<⏎> { prompt(" " x 6 ~  "← ") }

class Bc {
    has $!bc;

    submethod BUILD( :$!bc ) {}

    method send( Str $str ) {
        $!bc.print($str.trim ~ "\n");
    }

    method get-next( @outputs ){
        my $next = ⏎;
        $next.trim;
        if ! $next {
            $!bc.close-stdin;
        }
        if $next ~~ /"@" $<output> = (\d*) / {
            my $index = $<output> ne "" ?? $<output> - 1 !! @outputs.elems - 1;
            my $result = @outputs[$index] // 0;
            $next ~~ s/"@"\d*/$result/;
        }
        self.send($next);
    }
}

my $bc = Proc::Async.new: :w, ‘bc’, ‘-l’;
my $this-bc = Bc.new( :$bc );
my @outputs;

$bc.stdout.tap: -> $res {
    @outputs.append: $res.trim;
    say "[ {@outputs.elems} ] → ", $res;
    $this-bc.get-next(@outputs);
}

$bc.stderr.tap: {
    say ‘Error in input ’, $_;
    $this-bc.get-next($@outputs);
}

my $next = ⏎;
my $promise = $bc.start;
$this-bc.send($next);
await $promise;

