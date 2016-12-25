use feature 'say';
use Data::Dumper qw(Dumper);

my $l = 0;

sub run {
	my ($r, $cond) = @_;
	my $i = 0;
	while($cond->($i)) {
		my $c;
		read STDIN, $c, 1;
		$i++;
		if($c eq "(") {
			my $p = "", $ri = "";
			while() {
				$c = "";
				read STDIN, $c, 1;
				$i++;
				if($c =~ /^\d*$/) {
					$p .= $c;
				} else {
					last;
				}
			}
			die "bad repeat" if $c ne "x";
			while() {
				$c = "";
				read STDIN, $c, 1;
				$i++;
				if($c =~ /^\d*$/) {
					$ri .= $c;
				} else {
					last;
				}
			}
			die "bad repeat" if $c ne ")";
			# my $s = "";
			# read STDIN, $s, $p;
			$i += $p;
			run($r * $ri, sub {
				my ($i) = @_;
				if($i > $p) {
					die "bad: $i > $p";
				} elsif($i == $p) {
					0
				} else {
					1
				}
			});
		} else {
			$l += $r;
		}
	}
}

run 1, sub { !eof STDIN };

# until(eof STDIN) {
# 	my $c;
# 	read STDIN, $c, 1;
# 	if($c eq "(") {
# 		my $p = "", $r = "";
# 		while() {
# 			$c = "";
# 			read STDIN, $c, 1;
# 			if($c =~ /^\d*$/) {
# 				$p .= $c;
# 			} else {
# 				last;
# 			}
# 		}
# 		die "bad repeat" if $c ne "x";
# 		while() {
# 			$c = "";
# 			read STDIN, $c, 1;
# 			if($c =~ /^\d*$/) {
# 				$r .= $c;
# 			} else {
# 				last;
# 			}
# 		}
# 		die "bad repeat" if $c ne ")";
# 		my $s = "";
# 		read STDIN, $s, $p;
# 		$l += $p * $r;
# 		# say "(${p}x$r)$s";
# 	} else {
# 		$l += $r;
# 		# print $c;
# 	}
# }
say $l;
