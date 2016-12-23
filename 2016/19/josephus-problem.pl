use feature 'say';

sub run {
	my ($n) = @_;
	my %alive;
	@alive{0..$n-1} = ();
	my $current = 0;

	while() {
		# say sort keys %alive;
		# say "current: " . $current;
		last if keys %alive <= 1;
		my $kill = ($current + 1)%$n;
		while(!exists $alive{$kill} || $kill == $current) {
			$kill = ($kill + 1)%$n
		}
		# say "kill: " . $kill;
		delete $alive{$kill};
		last if keys %alive <= 1;
		my $next = ($kill + 1)%$n;
		while(!exists $alive{$next} || $next == $current) {
			$next = ($next + 1)%$n
		}
		# say "next: " . $next;
		$current = $next;
	}
	say $current;
}

for my $i (1..200) {
	next if $i%2 == 0;
	print $i . ": ";
	run($i);
}
