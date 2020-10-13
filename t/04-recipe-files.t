use Test; # -*- mode: perl6 -*-

use Raku::Recipes::Texts;

my $recipes-text = Raku::Recipes::Texts.new();

subtest "Test basic load", {
    my %recipes = $recipes-text.recipes;
    ok( %recipes, "Loads recipes");
    ok( "Buckwheat pudding" ∈ %recipes.keys,
            "We have buckwheat pudding");
    ok( %recipes{"Buckwheat pudding"},
            "Includes key «$_»" ) for <description ingredients>;
    like( %recipes{"Buckwheat pudding"}<path>, /buckwheat\-pudding/,
    "Path is OK" );
    isa-ok %recipes{'Tuna risotto'}<ingredients>[0],
            Str, "Ingredients extracted";
}

subtest "Generate site", {
    lives-ok { $recipes-text.generate-site() }, "Generates site";
}
done-testing;
