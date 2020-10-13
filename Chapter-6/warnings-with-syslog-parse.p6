#!/usr/bin/env raku

use Syslog::Grammar;
use Syslog::Grammar::Actions;

"/var/log/syslog".IO.lines
    ==> map( { Syslog::Grammar.parse( $_,
                                      actions => Syslog::Grammar::Actions.new ).made; } )
    ==> grep( { $_<message> ~~ m:i/warn/ }  )
    ==> my @lines;

for @lines -> %w {
    say "⇒ %w<actor> has warned about\n\t%w<message>\n\tby $%w<hour>";
}


