use feature 'say';
use Data::Dumper qw(Dumper);

while(<>) {
	if(/^(.*)-(\d*)\[(.*)\]$/) {
		my @name = split /-/, $1;
		my $sector_id = $2;
		my $checksum = $3;

		my %letters;
		for my $c (split //, join "", @name) {
			$letters{$c}++;
		}
		my $wat = sub {
			my $r = ($letters{$a} <=> $letters{$b}) || ($b cmp $a);
			return $r;
		};
		my $cs2 = substr join("", reverse sort $wat keys %letters), 0, 5;
		if($checksum eq $cs2) {
			say "$sector_id: " . join " ", map {
				my $s = $_;
				join "", map {
					chr(ord('a') + (ord($_) - ord('a') + $sector_id)%26)
				} map substr($s, $_, 1), 0..length($s)-1
			} @name;
		}
	}
}
