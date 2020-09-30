#!/usr/bin/perl

use strict;
use warnings;
use JSON::XS;
use Time::HiRes qw(gettimeofday tv_interval);
use Text::ASCIITable;

sub run {#{{{
	my $cmd = shift;

	my $start = [gettimeofday];
	system($cmd);

	if ($? == -1) {
		print "failed to execute: $!\n";
		return undef;
	}
	elsif ($? & 127) {
		printf "child died with signal %d, %s coredump\n",
		($? & 127),  ($? & 128) ? 'with' : 'without';
		return undef;
	}
	else {
		my $e = $? >> 8;
		if ($e != 0) {
			printf "child exited with value %d\n", $e;
			return undef;
		}
	}
	return tv_interval($start);
}#}}}

sub main {#{{{

	system('mkdir -p outputs');

	my $all = {
		cpp => {
			pre => 'clang++ -O2 -o uwc.cpp.bin uwc.cpp -std=c++11',
			cmd => './uwc.cpp.bin',
		},
		sh => {
			pre => '',
			cmd => 'sh ./uwc.sh',
		},
		php => {
			pre => '',
			cmd => 'php ./uwc.php',
		},
		pl => {
			pre => '',
			cmd => 'perl ./uwc.pl',
		},
		py => {
			pre => '',
			cmd => 'python uwc.py',
		},
		rb => {
			pre => '',
			cmd => 'RUBYOPT="-KU -E utf-8:utf-8" ruby uwc.rb',
		},
		js => {
			pre => '',
			cmd => 'node uwc.js',
		},
		java => {
			pre => 'javac uwc.java',
			cmd => 'java uwc',
		},
		go => {
			pre => 'go build -o uwc.go.bin uwc.go',
			cmd => './uwc.go.bin',
		},
	};

	my $r = {};
	my $mins = {};

	my $fieldnames = ['Lang'];
	opendir (DIR, 'inputs') or die $!;
	while (my $file = readdir(DIR)) {
		$file =~ /^\./ and next;
		$mins->{$file} = undef;

		push @{$fieldnames}, $file;
		foreach my $p ( keys %{$all} ) {
			my $e = $all->{$p};

			print "Processing $file with $p\n";
			system($e->{pre}) if $e->{pre};
			$r->{$p}->{$file} = run("$e->{cmd} < inputs/$file > outputs/${p}_${file}");
			if (defined $r->{$p}->{$file}) {
				if (not defined($mins->{$file}) or ($mins->{$file} > $r->{$p}->{$file})) {
					$mins->{$file} = $r->{$p}->{$file};
				}
			}
		}
	}
	closedir(DIR);

	my $t = Text::ASCIITable->new({ headingText => 'Summary', utf8 => 0 });
	$t->setCols(@{$fieldnames});
	foreach my $p ( sort keys %{$r} ) {
		$t->addRow(map { $_ eq 'Lang' ? $p : (defined($r->{$p}->{$_}) ? sprintf('%.3fs (%6.1f%%)',
				$r->{$p}->{$_},
				$mins->{$_} == 0 ? 0 : (100.0 * $r->{$p}->{$_} / $mins->{$_})
				) : '---')
			} @{$fieldnames});
	}

	print $t->draw;
}#}}}

exit main(@ARGV);
