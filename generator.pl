#!/usr/bin/env perl

use strict;
use warnings;
use File::Path;
use File::Basename;
use File::Spec;
use Getopt::Long;
use Cwd;
 
my $perl = $^X;

my $verbose;
my $output;

GetOptions(
           'output=s' => \$output,
           'verbose' => \$verbose
);

print("[", $$, "] Generator (", scalar @ARGV, "): ", $_, "\n") for (@ARGV);

my $outputPath = File::Spec->rel2abs($output);
mkpath($outputPath);

foreach my $argument (@ARGV) {
    my $headerPathToWrite = $outputPath . "/JS" . basename($argument, ".serialized") . ".h";
    open(FH, '>', $headerPathToWrite) or die $!;
    print(FH $headerPathToWrite);
    close(FH);
    print("[", $$, "] Generator wrote out: ", $headerPathToWrite, "\n");

    my $cppPathToWrite = $outputPath . "/JS" . basename($argument, ".serialized") . ".cpp";
    open(FH, '>', $cppPathToWrite) or die $!;
    print(FH $cppPathToWrite);
    close(FH);
    print("[", $$, "] Generator wrote out: ", $cppPathToWrite, "\n");
}

print("\n");

exit 0;
