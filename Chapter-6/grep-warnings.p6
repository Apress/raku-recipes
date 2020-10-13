#!/usr/bin/env raku

my @syslog = "/var/log/syslog".IO.lines;

say @syslog.grep: /"-WARNING**"/;
