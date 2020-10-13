#!/usr/bin/env perl6

use Telegram;
use Raku::Recipes::Grammar::Measured-Ingredients;
use Raku::Recipes::Grammar::Actions;
use Raku::Recipes::Roly;

my $bot = Telegram::Bot.new(%*ENV<RAKU_RECIPES_BOT_TOKEN>);
my $rrr = Raku::Recipes::Roly.new;

$bot.start(1);

react {
    whenever $bot.messagesTap -> $msg {
        say $msg.raku;
        my $item =  Raku::Recipes::Grammar::Measured-Ingredients.parse(
                $msg.text,
                actions =>
                    Raku::Recipes::Grammar::Actions::Measured-Ingredients
                            .new).made;

        if $item {
            my $calories = $rrr.calories( $item );
            $bot.sendMessage($msg.chat.id,
            "{$item.value.value} {$item.value.key} of {$item.key} has $calories calories");
            say "{ $msg.sender.username }: { $msg.text } in { $msg.chat.id } → $item";
        } else {
            say "There's something wrong with the input string; can't compute calories";
            $bot.sendMessage( $msg.chat.id,
                    "Sorry, can't compute '{$msg.text}'");
        }
    }
    whenever signal(SIGINT) {
        $bot.stop;
        exit;
    }
}