#!/usr/bin/env perl

use v5.20;

use MealMaster;

my $parser = MealMaster->new();
my @recipes = $parser->parse(shift // "apetizer.mmf");
foreach my $r (@recipes) {
  print "Title: " . $r->title . "\n";
  print "Categories: " . join(", ", sort @{$r->categories}) . "\n";
  print "Yield: " . $r->yield . "\n";
  print "Directions: " . $r->directions . "\n";
  print "Ingredients:\n";
  foreach my $i (@{$r->ingredients}) {
    print "  " . $i->quantity .
           " " . $i->measure  .
           " " . $i->product .
           "\n";
  }
}
