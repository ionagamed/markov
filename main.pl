use strict;
use warnings;

# Generates text using Markov chains. Builds tuples of $depth words, and goes into next state using frequencies as random chance.
# Time:
# 	Linear in size and depth
# Memory:
# 	O($size ^ $depth)

use Getopt::Long;

my @words;
my $size = 1000;
my $newlines = '';
my $depth = 3;

GetOptions(
		"words=i" => \$size,
		"newlines" => \$newlines,
		"depth=i" => \$depth
);

while (<>) {
	if (!$newlines) {
		chomp;
	}
	push(@words, split(/ /));
}

my %freq = ();

my @state = ("#") x $depth;
foreach (@words) {
	shift @state;
	$freq{join("#", @state)}{$_}++;
	push @state, $_;
}

@state = ("#") x $depth;
for (my $i = 0; $i <= $size; $i++) {
	shift @state;
	my $r = rand();
	my $c = 0.0;
	my $f = 0.0;
	my $st;
	foreach (keys %{ $freq{join("#", @state)} }) {
		my $p = $freq{join("#", @state)}{$_};
		$f += $p;
	}
	foreach (keys %{ $freq{join("#", @state)} }) {
		my $p = $freq{join("#", @state)}{$_};
		if ($r >= $c && $r <= $c + $p / $f) {
			$st = $_;
			last;
		}
		$c += $p / $f;
	}
	print $st, " ";
	push @state, $st;
}
