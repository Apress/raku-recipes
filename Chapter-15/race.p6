#!/usr/bin/env raku

# Grab Nutrients.csv from https://data.nal.usda.gov/dataset/usda-branded-food-products-database/resource/c929dc84-1516-4ac7-bbb8-c0c191ca8cec
my @nutrients = "/home/jmerelo/Documentos/Nutrients.csv".IO.lines;
my $degree = @*ARGS[0] // 4;
my $time = now;
my @selected = @nutrients.race( :batch(@nutrients/$degree), :$degree ).grep: {
    my @data = $_.split('","');
    @data[2] eq "Protein" and @data[3] eq "LCCS" and @data[4] > 70 and @data[5] ~~ /^g/;
};
say now - $time;
say @selected.join: "\n";
