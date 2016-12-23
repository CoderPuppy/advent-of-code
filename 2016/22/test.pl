use feature 'say';
use Data::Dumper qw(Dumper);
use List::Util qw(min max);

<>; <>;

my @nodes_map;
my @nodes_list;

while(<>) {
	if(/^\/dev\/grid\/node-x(\d*)-y(\d*)\s*(\d*)T\s*(\d*)T\s*(\d*)T\s*(\d*)%$/) {
		my $node = {
			"x" => $1,
			"y" => $2,
			"size" => $3,
			"used" => $4,
			"avail" => $5
		};
		$nodes_map[$1][$2] = $node;
		push @nodes_list, $node;
	} else {
		die "Wat: $_";
	}
}

my @buckets;
my $low = min map { $_->{avail} } @nodes_list;
my $high = max map { $_->{avail} } @nodes_list;
say "$low-$high";
for my $node (@nodes_list) {
	for my $bi ($node->{used}..$high) {
		push @{$buckets[$bi]}, $node;
	}
}
my @bucket_hs;
for my $bi (0..$#buckets) {
	my %bh;
	for my $node (@{$buckets[$bi]}) {
		$bh{$node} = 1;
	}
	@bucket_hs[$bi] = \%bh;
}
my $n = 0;
for my $node_a (@nodes_list) {
	for my $node_u (@{$buckets[$node_a->{avail}]}) {
		if($node_u->{used} > 0 && $node_a != $node_u) {
			$n++;
		}
	}
}
say $n;
