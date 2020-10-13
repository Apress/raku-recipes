use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Raku::Recipes::Grammar::Measured-Ingredients;
use Raku::Recipes::Roly;

my $rrr = Raku::Recipes::Roly.new;

sub routes() is export {
    route {
        my $chat = Supplier.new;
        get -> 'calories' {
            web-socket -> $incoming {
                supply {
                    whenever $incoming -> $message {
                        $chat.emit(await $message.body-text);
                    }
                    whenever $chat -> $text {
                        # Compute calories here
                        my $item =
                                Raku::Recipes::Grammar::Measured-Ingredients
                                .parse( $text );
                        my $calories = $rrr.calories( ~$item<ingredient>,
                                +$item<quantity>);
                        emit "Calories: for $text ⇒ $calories";
                    }
                }
            }
        }
    }
}
