#!/usr/bin/env raku

my $proc = Proc::Async.new( 'tail', '-f',  '/var/log/syslog' );

$proc.stdout.tap(-> $v {
    print "Gnome session event→\n\t$v" if $v.contains("gnome-session");
});

$proc.stdout.tap(-> $v  {
    print "Sync event: $v" if  $v.contains('time server');
});

say "Listening to /var/log/syslog";
await $proc.start;
say "Finished";