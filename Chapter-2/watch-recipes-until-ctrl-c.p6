#!/usr/bin/env raku

my $dir = @*ARGS[0] // 'recipes';

my $dir-watch-supply= $dir.IO.watch;
my $ctrl-c = Promise.new;

$dir-watch-supply.tap: -> $change {
    given $change.event {
        when FileChanged { say "{$change.path} has changed"}
        when FileRenamed { say "{$change.path} has been renamed, deleted or created" }
    }
};
signal(SIGINT).tap( { say "Exiting"; $ctrl-c.keep } );

await $ctrl-c;
