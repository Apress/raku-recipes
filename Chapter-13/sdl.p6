#!/usr/bin/env perl6

use SDL2::Raw;
use lib <lib Chapter-13/lib>;
use SDL2;
use My::Unit;


LEAVE SDL_Quit;

my $occupied =  @*ARGS[0] // 0.5;

my int ($w, $h) = 800, 600;
my $window = init-window( $w, $h );
LEAVE $window.destroy;

my $renderer = SDL2::Renderer.new( $window, :flags(ACCELERATED) );
SDL_ClearError;

my @grid[$w/GRID_X;$h/GRID_Y];
say "Generating grid...";
for ^@grid.shape[0] -> $x {
    for ^@grid.shape[1] -> $y {
        if ( 1.rand < $occupied ) {
            @grid[$x;$y] = My::Unit.new( :$renderer, :$x, :$y );
            @grid[$x;$y].render;
        }
    }
}
sdl-loop($renderer);

#-------------------- routines -----------------------------------------

#| Init window
sub init-window( int $w, int $h ) {
    die "couldn't initialize SDL2: { SDL_GetError }" if SDL_Init(VIDEO) != 0;
    SDL2::Window.new(
            :title("DIVCO"),
            :width($w),
            :height($h),
            :flags(SHOWN)
            );
}

#| Rendering loop
sub sdl-loop ( $renderer ) {
    my SDL_Event $event .= new;
    loop {
        state $last-update = now;
        while SDL_PollEvent($event) {
            handle-event( $renderer, SDL_CastEvent($event) );
        }
        if now - $last-update  > 1 {
            infection-loop($renderer);
            $last-update = now;
        }
    }
}

#| Handle events
proto sub handle-event( | ) {*}

multi sub handle-event( $, SDL2::Raw::SDL_MouseButtonEvent $mouse ) {
    my ( $grid-x, $grid-y ) = gridify( $mouse.x, $mouse.y );
    given $mouse {
        when (*.type == MOUSEBUTTONUP ) {
            with @grid[$grid-x; $grid-y] {
                .flip;
            }
        }
    }
}

sub gridify ( $x, $y) {
    return ($x / GRID_X).Int, ($y/GRID_Y).Int;
}

multi sub handle-event( $, SDL2::Raw::SDL_KeyboardEvent $key ) {
    given $key {
        when (*.type == KEYDOWN )
        {
            if $key.sym == 27 {
                exit;
            }
        }
    }
}

multi sub handle-event( $, $event ) {
    given $event {
        when ( *.type == QUIT )
        {
            exit;
        }
    }
}

sub infection-loop( $renderer ) {
    say "Infection loop…";
    for ^@grid.shape[0] -> $x {
        for ^@grid.shape[1] -> $y {
            with @grid[$x; $y] {
                if .state == HEALTHY {
                    my $prob=0;
                    for max($x - 1, 0) .. min($x + 1, @grid.shape[0] - 1) ->
                    $xx {
                        for max($y - 1, 0) .. min($y + 1,
                                @grid.shape[1] - 1) ->
                        $yy {
                            if @grid[$xx;$yy] && @grid[$xx;$yy].state ==
                            INFECTED {
                                $prob += 0.5
                            }
                        }
                    }
                    if 1.rand < $prob {
                        @grid[$x;$y].flip;
                    }
                }
            }
        }
    }
    $renderer.present;
}