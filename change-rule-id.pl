#!/usr/bin/perl
use strict;
use warnings;

open my $in, '<', 'msauth_rules.xml' or die "$! opening input";
open my $out, '>', 'new_msauth_rules.xml' or die "$! opening output";

my $counter = 18100;

while (<$in>) {
    s/rule id="[0-9]*"/q{rule id="} . $counter++ . "\"" /eg;
    print $out $_;
}
