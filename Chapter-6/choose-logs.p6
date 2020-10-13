#!/usr/bin/env raku

use Term::Choose :choose;
use Term::TablePrint;
use Libarchive::Filter;

my @files = dir( "/var/log", test => { "/var/log/$_".IO.f } );

while @files {
    my $file = choose( @files.map( *.Str ),
            :prompt("Choose file or 'q' to exit") );
    last unless $file;
    my $i;
    my $content;
    if $file ~~ /\.gz$/ {
	$content = archive-decode($file, filter=>'gzip');
    } else {
       $content = $file.IO;
    }
    my @lined-file= $content.lines.map: { [ ++$i, $_ ] }
    print-table([ ['⇒',$file], |@lined-file ]);
};

