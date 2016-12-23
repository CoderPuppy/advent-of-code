use feature 'say';
use Data::Dumper qw(Dumper);
use Data::Dumper;
use List::Util qw(min max);

sub my_dump {
	my ($name, $val) = @_;
	print Data::Dumper->new([$val], [$name])->Dump;
}

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

sub dijkstras {
	my ($src, $dst) = @_;

	my %paths;
	my @open;
	push @open, $src;
	$paths{$src} = [0];

	sub open_cmp { $paths{$a}->[0] <=> $paths{$b}->[0] }

	sub neighbors {
		my ($node) = @_;
		my $x = $node->{x}, $y = $node->{y};
		my @out;
		my $try = sub {
			my ($x, $y) = @_;
			my $node = $nodes_map[$x][$y];
			push @out, $node if defined $node;
		};
		$try->($x - 1, $y);
		$try->($x + 1, $y);
		$try->($x, $y - 1);
		$try->($x, $y + 1);
		return \@out;
	}

	while(@open) {
		my $node = shift @open;
		if($node == $dst) {
			my @path;
			my $node = $dst;
			while() {
				my $next = $paths{$node}->[1];
				last if !defined $next;
				unshift @path, $node;
				$node = $next;
			}
			return \@path;
		}
		for my $n (@{neighbors($node)}) {
			if(!defined $paths{$n} || $paths{$node}->[0] + 1 < $paths{$n}->[0]) {
				@open = sort open_cmp, $n, @open;
				$paths{$n} = [$paths{$node}->[0] + 1, $node];
			}
		}
	}

	die "no path";
}

my ($empty) = grep { $_->{used} == 0 } @nodes_list;
my ($goal) = $nodes_map[max map { $_->{x} } grep { $_->{y} == 0 } @nodes_list][0];
my_dump "empty", $empty;
my_dump "goal", $goal;
my @path = @{dijkstras($empty, $nodes_map[$goal->{x} - 1][$goal->{y}])};
my_dump "#path", scalar @path;
my_dump "path", \@path;
