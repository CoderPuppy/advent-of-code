use feature 'say';
use Data::Dumper qw(Dumper);

my $n = 0;
while(<>) {
	if(/^(.*)-(\d*)\[(.*)\]$/) {
		my @name = split /-/, $1;
		my $sector_id = $2;
		my $checksum = $3;

		my %letters;
		for my $c (split //, join "", @name) {
			$letters{$c} = 0;
		}
		for my $c (split //, join "", @name) {
			$letters{$c}++;
		}
		# say Dumper(\%letters);
		my $wat = sub {
			my $r = ($letters{$a} <=> $letters{$b}) || ($b cmp $a);
			# say "'$a' ($letters{$a}) <=> '$b' ($letters{$b}) = $r";
			return $r;
		};
		my $cs2 = substr join("", reverse sort $wat keys %letters), 0, 5;
		# say "i:" . $checksum;
		# say "c:" . $cs2;
		if($checksum eq $cs2) {
			$n += $sector_id;
		}
	}
}
say $n;
