use feature 'say';
use Data::Dumper qw(Dumper);

my @discs;
while(<>) {
	if(/^Disc #(\d*) has (\d*) positions; at time=0, it is at position (\d*).$/) {
		push @discs, [$2, $3, 0];
	} else {
		die "Wat: $_";
	}
}

my $t = 0;
while() {
	my $ready = 1;
	my $i = 0;
	# say "---- $t";
	for my $disc (@discs) {
		# say "$i: @$disc";
		my $has = @$disc[2];
		if($ready && !@$disc[1]) {
			@$disc[2] = 1;
		} else {
			@$disc[2] = 0;
		}
		$ready = $has;
		@$disc[1] = (@$disc[1] + 1)%@$disc[0];
		$i++;
	}
	if(@{$discs[-1]}[2]) {
		say $t - @discs;
	}
	$t++;
}
