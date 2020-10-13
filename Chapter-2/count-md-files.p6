#!/usr/bin/env raku

my $find-proc = Proc::Async.new: 'find', @*ARGS[0] // "recipes", "-name", "*.md";
my $wc-proc = Proc::Async.new: ‘wc’;

$wc-proc.bind-stdin: $find-proc.stdout;
$wc-proc.stdout.tap( { $_.print } );

my $wc = $wc-proc.start;
my $find = $find-proc.start;
await $wc, $find;
say "✓ Finished"

