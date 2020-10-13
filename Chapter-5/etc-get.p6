#!/usr/bin/env raku

my $can-haz-etcdctl = shell "etcdctl --version", :out;

my $output = $can-haz-etcdctl.out.slurp;
die "Can't find etcdctl" unless $output ~~ /"etcdctl version"/;

for @*ARGS -> $key {
    my $output = shell "etcdctl get $key", :out;
    my $value = $output.out.slurp.trim;
    say "🔑 $key -> $value";
}

