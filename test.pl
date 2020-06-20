#!/usr/bin/env perl

use strict;
use warnings;
use File::Path;
use File::Basename;
use File::Spec;
use Getopt::Long;
use IO::Handle;
use Cwd;
no warnings 'experimental::smartmatch';

my $perl = $^X;

my $verbose;

GetOptions(
           'verbose' => \$verbose
);

sub cleanup
{
    if ($verbose) {
        system("make", "clean");
    } else {
        `make clean`        
    }
}

sub make
{
    if ($verbose) {
        system("make");
    } else {
        `make`        
    }
}

my @outputFiles = (
    "out",
    "out/generated",
    "out/generated/JSFoo.h",
    "out/generated/JSFoo.cpp",
    "out/generated/JSBar.h",
    "out/generated/JSBar.cpp",
    "out/serialized",
    "out/serialized/Foo.serialized",
    "out/serialized/Bar.serialized",
);

my @resultFilesThatExist = ();
my @resultFilesThatDontExist = ();

sub updateResults
{
    @resultFilesThatExist = ();
    @resultFilesThatDontExist = ();
    
    foreach my $outputFile (@outputFiles) {
        if (-e $outputFile) {
            push(@resultFilesThatExist, $outputFile);
        } else {
            push(@resultFilesThatDontExist, $outputFile);
        }
    }
}


cleanup();
updateResults();
die "Could not establish clean starting condition\n." unless scalar(@resultFilesThatExist) == 0;

print("Testing basic 'make'.\n");
make();
updateResults();
if (scalar(@resultFilesThatDontExist) == 0) {
    print("PASS: Calling 'make' generated all the files.\n");
} else {
    print("FAIL: Something went wrong. Not all the files got generated. Missing: ", join(" ", @resultFilesThatDontExist), " Ending test run.\n");
    exit -1;
}

my $jsFooCpp = "out/generated/JSFoo.cpp";
my $fooSerialized = "out/serialized/Foo.serialized";

print("\nTesting make after JSFoo.cpp is removed.\n");
unlink $jsFooCpp or die "Could not delete '${jsFooCpp}'\n";
make();
updateResults();
if ($jsFooCpp ~~ @resultFilesThatExist) {
    print("PASS: Calling 'make' caused JSFoo.cpp to be regenerated.\n");
} else {
    print("FAIL: Something went wrong. JSFoo.cpp was not regenerated. Ending test run.\n");
    exit -1;
}

print("\nTesting make after Foo.serialized is removed.\n");
unlink $fooSerialized or die "Could not delete '${fooSerialized}'\n";
make();
updateResults();
if ($fooSerialized ~~ @resultFilesThatDontExist) {
    print("PASS: Calling 'make' did not cause Foo.serialized to be regenerated.\n");
} else {
    print("FAIL: Something went wrong. Foo.serialized got regenerated but should not have. Ending test run.\n");
    exit -1;
}

print("\nTesting make after Foo.serialized and JSFoo.cpp are removed.\n");
unlink $jsFooCpp or die "Could not delete '${jsFooCpp}'\n";
make();
updateResults();
if ($jsFooCpp ~~ @resultFilesThatExist) {
    print("PASS: Calling 'make' caused JSFoo.cpp to be regenerated.\n");
} else {
    print("FAIL: Something went wrong. JSFoo.cpp was not regenerated. Ending test run.\n");
    exit -1;
}
if ($fooSerialized ~~ @resultFilesThatExist) {
    print("PASS: Calling 'make' caused Foo.serialized to be regenerated.\n");
} else {
    print("FAIL: Something went wrong. Foo.serialized was not regenerated. Ending test run.\n");
    exit -1;
}

# FIXME: Add test that touching Foo.idl causes regeneration.


cleanup();
print("\nTest complete\n");
