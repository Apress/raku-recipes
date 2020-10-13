#!/usr/bin/env perl6

use GTK::Simple;
use GTK::Simple::App;
use GTK::Simple::RadioButton;
use Raku::Recipes::SQLator;

my $app = GTK::Simple::App.new( title => "Select ingredients" );

my $dator = Raku::Recipes::SQLator.new();
my @all-radio;

my @panels = do for <Main Side Dessert> {
    create-type-panel( $dator, $_)
};

for @all-radio -> $b {
    $b.toggled.tap: &grayout-same-name;
}

$app.set-content(
            GTK::Simple::VBox.new(
                create-type-buttons( @panels ),
                GTK::Simple::HBox.new( |@panels )
            )
        );

$app.border-width = 15;
$app.run;

END {
    say "Selected ingredients →";
    say @all-radio.grep(  *.status ).map( *.label ).join(" | ");
}

sub create-type-buttons( @panels ) {
    my $button-set = GTK::Simple::HBox.new(
            my $vegan = GTK::Simple::Button.new(label => "Vegan"),
            my $dairy = GTK::Simple::Button.new(label => "Non-Dairy"),
            my $exit = GTK::Simple::Button.new(label => "Exit"),
            );
    $vegan.clicked.tap: { toggle-buttons( $_, "Vegan" )};
    $dairy.clicked.tap: { toggle-buttons( $_, "Dairy" )};
    $exit.clicked.tap({ $app.exit; });
    return $button-set;
}

sub create-radio-buttons ( $dator, @labels is copy ) {
    my $label = shift @labels;
    my $first-radio-button =
            GTK::Simple::RadioButton.new(:$label )
            but $dator.get-ingredient($label);
    my @radio-buttons = ( $first-radio-button ) ;
    while @labels {
        $label = shift @labels;
        my $this-radio-button =
                GTK::Simple::RadioButton.new(:$label)
                but $dator.get-ingredient($label);
        @radio-buttons.append: $this-radio-button;
        $this-radio-button.add( $first-radio-button );
    }
    @all-radio.append: |@radio-buttons;
    @radio-buttons;
}

sub create-button-set( $dator, $title, @labels ) {
    my $label = GTK::Simple::TextView.new;
    $label.text = "→ $title";
    my @radio-buttons = create-radio-buttons( $dator, @labels );
    GTK::Simple::VBox.new( $label, |@radio-buttons);
}

sub create-type-panel( Raku::Recipes::Dator $dator,
                       $type where $type ∈ <Main Side Dessert> ) {
    my @ingredients = $dator.search-ingredients( { $type => "Yes" });
    create-button-set( $dator, $type, @ingredients );
}

sub toggle-buttons( $button, $type ) {
    state $clicked = False;
    if $clicked {
        $button.label = "Non-$type";
        for @all-radio -> $b {
            if $b.Hash{$type} eq "Yes" {
                $b.sensitive = False;
            } else {
                $b.sensitive = True;
            }
        }
        $clicked = False;
    } else {
        $button.label = $type;
        for @all-radio -> $b {
            $b.sensitive = $b.Hash{$type} eq "No";
        }
        $clicked = True;
    }

}

sub grayout-same-name( $b ) {
    state $toggled = False;
    if $toggled {
        for @all-radio -> $other {
            if $b !=== $other and $b.label eq $other.label {
                $other.sensitive = False;
            }
        }
        $toggled = False;
    } else {
        for @all-radio -> $other {
            if $b.WHICH ne $other.WHICH and $b.label eq $other.label {
                $other.sensitive = True;
            }
        }
        $toggled = True;
    }
}