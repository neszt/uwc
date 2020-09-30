#!/usr/bin/perl

use common::sense;
my %counts;

while (<STDIN>) {
	for (/([a-z']+)/goi) {
		$counts{$_}++;
	}
}

print join("\n", map { "$_ $counts{$_}" } sort { $counts{$a} <=> $counts{$b} || $a cmp $b } keys %counts) . "\n";
