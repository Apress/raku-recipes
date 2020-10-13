#!/usr/bin/env raku

# Grab Nutrients.csv from https://data.nal.usda.gov/dataset/usda-branded-food-products-database/resource/c929dc84-1516-4ac7-bbb8-c0c191ca8cec

.say for "/home/jmerelo/Documentos/Nutrients.csv".IO.lines.grep: {
    my @data = $_.split('","');
    $_ if @data[2] eq "Protein" and @data[4] > 70 and @data[5] ~~ /^g/
}
