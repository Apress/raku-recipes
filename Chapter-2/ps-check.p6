#!/usr/bin/env raku

# Run
# $ watch "ps -e | tail --lines=+2 >> /tmp/ps.log" before
my $proc = Proc::Async.new: 'tail', '-f', '/tmp/ps.log';

$proc.stdout.tap(-> $v {
    $v ~~ m:g/([\d+] ** 3 % ':') \s+ (\S+)/;
    with $/ {
        for $_.list -> $match {
	    my $command = $match[1];
	    my $time = $match[0];
	    given $command {
                when .contains("sh") {
		    say "Running shell $command for $time"
                }
                when none( "watch", "ps", "tail" ) { say "Seen $command" }
	    }
        }
    }
});

say "Listening to /tmp/ps.log";
await $proc.start;
say "Finished";
