use Cro::HTTP::Router;
use Raku::Recipes::Texts;

my $lock = Lock::Async.new;
my $builder = Channel.new;
my $p = start {
    react {
            whenever $builder {
                say "Waiting for lock…";
                $lock.protect: {
                    say "Rebuilding";
                    my $recipes-text = Raku::Recipes::Texts.new();
                    $recipes-text.generate-site();
                    say "Rebuilt";
                };

            }
    }
}

unit module My::Rebuild;

sub rebuild-route is export {
    route {
        get -> {
            $builder.send(True);
            content 'application/json', my %result = %( :building("Started") );
        }
    }

}
