use feature 'say';
use Data::Dumper qw(Dumper);

my @str;
for my $c (split "", "fbgdceah") {
	push @str, $c;
}

my %rotmap;
for my $i (0..@str-1) {
	my $rot = $i + 1;
	$rot++ if $i >= 4;
	my $j = ($i + $rot)%@str;
	say "rotmap $i, $rot, $j";
	die "bad: $i, $rot, $j" if defined $rotmap{$j};
	$rotmap{$j} = $rot;
}

while(<>) {
	chomp $_;
	say join "", @str;
	say $_;
	if(/^swap position (\d*) with position (\d*)$/) {
		my $tmp = $str[$2];
		$str[$2] = $str[$1];
		$str[$1] = $tmp;
	} elsif(/^swap letter (.) with letter (.)$/) {
		for my $i (0..@str-1) {
			if($str[$i] eq $1) {
				$str[$i] = $2;
			} elsif($str[$i] eq $2) {
				$str[$i] = $1;
			}
		}
	} elsif(/^reverse positions (\d*) through (\d*)$/) {
		@str[$1..$2] = reverse @str[$1..$2];
	} elsif(/^rotate left (\d*) steps?$/) {
		for my $i (1..$1) {
			unshift @str, pop @str;
		}
	} elsif(/^rotate right (\d*) steps?$/) {
		for my $i (1..$1) {
			push @str, shift @str;
		}
	} elsif(/^move position (\d*) to position (\d*)$/) {
		my ($e) = splice @str, $2, 1;
		my $i = $1;
		# if($i > $1) {
		# 	$i--;
		# }
		splice @str, $i, 0, $e;
	} elsif(/^rotate based on position of letter (.)$/) {
		my $i = index join("", @str), $1;
		my $j = $rotmap{$i};
		for my $k (1..$j) {
			push @str, shift @str;
		}
	} elsif(/^$/) {
	} else {
		die("wat: '$_'");
	}
}
say join "", @str;
