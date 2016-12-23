use feature 'say';

my ($n) = @ARGV;
for(my $i = 0; ; $i++) {
	my $p = 2**$i;
	my $l = $n - $p;
	if($l < 2**($i - 1) && $l >= 0) {
		say "2^$i + $l = $n";
		last;
	}
}
