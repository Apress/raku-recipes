#!/usr/bin/env raku

my $can-haz-etcdctl = shell "etcdctl --version", :out;

my $output = $can-haz-etcdctl.out.slurp;
die "Can't find etcdctl" unless $output ~~ /"etcdctl version"/;

my $version = ($output ~~ / "API version: " (\d+) /);

my $setter = $version[0] ~~ /2/ ?? "set" !! "put";
    

sub MAIN( $key, $value ) {
    my $output = shell "etcdctl $setter $key $value", :out;
    my $set-value = $output.out.slurp.trim;
    if $value eq $set-value {
        say "🔑 $key has been set to $value";
    } else {
        die "Couldn't set $key to $value";
    }
}
      
