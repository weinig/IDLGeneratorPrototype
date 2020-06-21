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
my @allIDLs;

GetOptions(
           'output=s' => \$output,
           'i=s@' => \@allIDLs,
           'verbose' => \$verbose
);

my @changedIDLs = @ARGV;

print("[", $$, "] SerializerAndGenerator CHANGED IDLS (", scalar @changedIDLs, "): ", $_, "\n") for (@changedIDLs);
print("[", $$, "] SerializerAndGenerator ALL IDLS (", scalar @allIDLs, "): ", $_, "\n") for (@allIDLs);

my $outputPath = File::Spec->rel2abs($output);

mkpath($outputPath);
mkpath($outputPath . "/serialized");
mkpath($outputPath . "/generated");

my @serializedIDLs = ();
foreach my $changedIDL (@changedIDLs) {
    my $serializedName = basename($changedIDL, ".idl") . ".serialized";
    my $serializedPathToWrite = $outputPath . "/serialized/" . $serializedName;
    open(FH, '>', $serializedPathToWrite) or die $!;
    print(FH $serializedPathToWrite);
    close(FH);
    print("[", $$, "] SerializerAndGenerator serialized out: ", $serializedPathToWrite, "\n");
    push(@serializedIDLs, $serializedName);
}

foreach my $serializedIDL (@serializedIDLs) {
    my $headerPathToWrite = $outputPath . "/generated/JS" . basename($serializedIDL, ".serialized") . ".h";
    open(FH, '>', $headerPathToWrite) or die $!;
    print(FH $headerPathToWrite);
    close(FH);
    print("[", $$, "] Generator wrote out: ", $headerPathToWrite, "\n");

    my $cppPathToWrite = $outputPath . "/generated/JS" . basename($serializedIDL, ".serialized") . ".cpp";
    open(FH, '>', $cppPathToWrite) or die $!;
    print(FH $cppPathToWrite);
    close(FH);
    print("[", $$, "] Generator wrote out: ", $cppPathToWrite, "\n");
}

print("\n");

exit 0;
