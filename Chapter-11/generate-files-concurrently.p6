#!/usr/bin/env perl6

use Raku::Recipes::Texts;

my $builder = Channel.new;

my $p = start {
    react {
        whenever $builder {
            say "Building…";
            my $recipes-text = Raku::Recipes::Texts.new();
            $recipes-text.generate-site()
        }
    }
}

await (^3).map: -> $r {
    start {
        sleep $r;
        $builder.send($r);
    }
}

$builder.close;
await $p;
