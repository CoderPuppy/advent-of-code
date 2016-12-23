use feature 'say';
use Data::Dumper qw(Dumper);

my @str;
for my $c (split "", "egcdahbf") {
	push @str, $c;
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
			push @str, shift @str;
		}
	} elsif(/^rotate right (\d*) steps?$/) {
		for my $i (1..$1) {
			unshift @str, pop @str;
		}
	} elsif(/^move position (\d*) to position (\d*)$/) {
		my ($e) = splice @str, $1, 1;
		my $i = $2;
		# if($i > $1) {
		# 	$i--;
		# }
		splice @str, $i, 0, $e;
	} elsif(/^rotate based on position of letter (.)$/) {
		my $i = index join("", @str), $1;
		$i++ if $i >= 4;
		for my $j (0..$i) {
			unshift @str, pop @str;
		}
	} elsif(/^$/) {
	} else {
		die("wat: " . $_);
	}
}
say join "", @str;
