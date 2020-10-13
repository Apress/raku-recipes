#!/usr/bin/env raku

my $dir = @*ARGS[0] // 'recipes';

my $dir-watch-supply= IO::Notification.watch-path($dir);

$dir-watch-supply.tap: -> $change {
    given $change.event {
        when FileChanged { say "{$change.path} has changed"}
        when FileRenamed { say "{$change.path} has been renamed, deleted or created" }
    }
};

await Promise.in(30).then: { say "Finished watch"; };
