use feature 'say';

my @things;
while(<>) {
	if(/^([^-\s]*)\-([^-\s]*)$/) {
		push @things, [$1, $2];
	}
}
@things = sort { @$a[0] <=> @$b[0] } @things;
my $last = -1;
while() {
	last if scalar @things == 0;
	my $thing = shift @things;
	print $last . ": " . @$thing[0] . "-" . @$thing[1] . "\n";
	if(@$thing[0] > $last + 1) {
		say "HI!: " . ($last + 1);
		# last
	}
	$last = @$thing[1];
}
# print(map { @$_[0] . "\n" } @things);
