#!/usr/bin/env perl6


{ &_ = &?BLOCK; my \p = prompt;
    $^b > $^a
        ?? &_($^a, p("> "))
        !! $^b < $^a ?? &_($^a, p("< ")) !! "✓".say
}((1..6).pick,0)