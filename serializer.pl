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

print("[", $$, "] Serializer (", scalar @ARGV, "): ", $_, "\n") for (@ARGV);

my $outputPath = File::Spec->rel2abs($output);
mkpath($outputPath);

foreach my $argument (@ARGV) {
    my $pathToWrite = $outputPath . "/" . basename($argument, ".idl") . ".serialized";
    open(FH, '>', $pathToWrite) or die $!;
    print(FH $pathToWrite);
    close(FH);
    print("[", $$, "] Serializer wrote out: ", $pathToWrite, "\n");
}

print("\n");

exit 0;
