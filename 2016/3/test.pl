use feature 'say';
use Data::Dumper qw(Dumper);

my $n = 0;
while(<>) {
	$_ =~ s/^\s+|\s+$//g;
	my @sides = split /\s+/, $_;
	if($sides[0] + $sides[1] > $sides[2] && @sides[1] + @sides[2] > @sides[0] && @sides[0] + @sides[2] > @sides[1]) {
		$n++;
	}
}
say $n;
