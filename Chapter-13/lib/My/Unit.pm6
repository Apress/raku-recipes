use SDL2::Raw;

enum unit-state <HEALTHY INFECTED>;
constant OPAQUE = 255;

constant @infected = (255,0,0,OPAQUE);
constant @healthy = (0,255,0,OPAQUE);
constant GRID_X = 25;
constant GRID_Y = 25;

unit class My::Unit;

has $!renderer;
has $!x;
has $!y;
has unit-state $.state = HEALTHY;
has $!rect;

submethod BUILD( :$!renderer, :$!x, :$!y ) {}

submethod TWEAK {
    $!rect = SDL_Rect.new: x => $!x*GRID_X, y => $!y*GRID_Y,
                w => GRID_X, h => GRID_Y;
}

submethod flip() {
    $!state = $!state == HEALTHY ?? INFECTED !! HEALTHY;
    self.render;
}

method render {
    if $!state == HEALTHY {
        $!renderer.draw-color(|@healthy);
    } else {
        $!renderer.draw-color(|@infected);
    }
    $!renderer.fill-rect($!rect);
}
