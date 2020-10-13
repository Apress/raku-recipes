#!/usr/bin/env raku

my @warnings = "/var/log/syslog".IO.lines.grep: /warn/;

for @warnings -> $w {
    my ($metadata, $message) = $w.split( ": ", 2 );
    say "→ ", $metadata.split(/\s+/)[*-1],
        " has produced this message\n\t$message\n\n";
}
