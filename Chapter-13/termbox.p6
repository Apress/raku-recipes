#!/usr/bin/env perl6

use Termbox :ALL;
use Raku::Recipes::SQLator;

my %data = Raku::Recipes::SQLator.new.get-ingredients;
my Set $selected;

if tb-init() -> $ret {
    note "tb-init() failed with error code $ret";
    exit 1;
}

END tb-shutdown;

my $row = 0;
my $ingredient-index = 0;
my @ingredients = %data.keys.sort;
my $max-len = @ingredients.map: { .codes };
my $split = @ingredients.elems / 2;
print-string("Select with ENTER, move with space or cursors",1,1,
        TB_WHITE, TB_BLACK);
for @ingredients -> $k {
    my ($this-column,$this-row )  = ingredient-to-coords( $row );
    uncheck-mark( $row );
    print-string( $k , $this-column + 5, $this-row, TB_BLACK, TB_WHITE );
    $row++;
}
draw-cursor($ingredient-index);
tb-present;

my $events = Supplier.new;
start {
    while tb-poll-event( my $ev = Termbox::Event.new ) { $events.emit: $ev }
}

react whenever $events.Supply -> $ev {
    given $ev.type {
        when TB_EVENT_KEY {
            given $ev.key {
                when TB_KEY_SPACE | TB_KEY_ARROW_DOWN {
                    undraw-cursor($ingredient-index);
                    $ingredient-index =
                            ($ingredient-index+1) % @ingredients.elems;
                    my ( $this_column, $this_row ) = ingredient-to-coords
                            ($ingredient-index);
                    draw-cursor( $ingredient-index );
                    tb-present;
                }
                when TB_KEY_ARROW_UP {
                    undraw-cursor($ingredient-index);
                    if $ingredient-index {
                        $ingredient-index--
                    } else {
                        $ingredient-index = @ingredients.elems - 1;
                    }
                    my ( $this_column, $this_row ) = ingredient-to-coords
                            ($ingredient-index);
                    draw-cursor( $ingredient-index );
                    tb-present;
                }
                when TB_KEY_ENTER {
                    if @ingredients[$ingredient-index] ∈ $selected {
                        uncheck-mark($ingredient-index);
                        $selected ⊖= @ingredients[$ingredient-index];
                    } else {
                        check-mark($ingredient-index);
                        $selected ∪= @ingredients[$ingredient-index];
                    }
                    tb-present;
                }
                when TB_KEY_ESC {
                    print-string("Selected " ~
                            $selected.map( *.key ).join("-" ),
                            1,2,
                            TB_BLUE, TB_YELLOW);
                    tb-present;
                    sleep(5);
                    done
                }

            }
        }
    }
}

subset RowOrColumn of Int where * >= 1;

sub uncheck-mark( $ingredient-index ) {
    my ($this-column,$this-row )  = ingredient-to-coords( $ingredient-index );
    print-string( "[ ]", $this-column + 1 , $this-row, TB_BLACK, TB_BLUE );
}

sub check-mark( $ingredient-index ) {
    my ($this-column,$this-row )  = ingredient-to-coords( $ingredient-index );
    print-string( "[X]", $this-column + 1 , $this-row, TB_BLACK, TB_BLUE );
}

sub draw-cursor( $ingredient-index ) {
    my ($cursor_c, $cursor_r) = ingredient-to-coords( $ingredient-index);
    tb-change-cell( $cursor_c, $cursor_r, ">".ord, TB_YELLOW, TB_RED );

}

sub undraw-cursor( $ingredient-index ) {
    my ($cursor_c, $cursor_r) = ingredient-to-coords( $ingredient-index);
    tb-change-cell( $cursor_c, $cursor_r, " ".ord, 0, 0 );

}

sub print-string( Str $str, RowOrColumn $column,
                  RowOrColumn $row,
                  $fgcolor,
                  $bgcolor  ) {
    for $str.encode.list -> $c  {
        state $x;
        tb-change-cell( $column + $x++,
                $row,
                $c,
                $bgcolor, $fgcolor );
    }
}

sub ingredient-to-coords( UInt $ingredient-index) {
    return 1 + ($ingredient-index / $split).Int * ($max-len + 5),
            (3 + $ingredient-index % $split).Int;
}