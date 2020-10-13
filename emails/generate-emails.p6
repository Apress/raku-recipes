#!/usr/bin/env raku

my @tlds = <org com net es>;
my @domains = <gmail ymail kmail protonmail>;
my @names = <alice bob cecilia dan>;

for ^3 {
    my @emails;
    for ^20 {
	@emails.push: @names.pick ~ "@" ~ @domains.pick ~ "." ~ @tlds.pick;
    }
    say @emails.unique.join("\n"), "\n----------- 8< ---------";
}
