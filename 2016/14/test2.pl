use feature 'say';
use Data::Dumper qw(Dumper);
use Digest::MD5 qw(md5_hex);

# my $salt = "cuanljph";
my $salt = "abc";

my @out;

for(my $i = 0; ; $i++) {
	my $h = md5_hex($salt . $i);
	if($h =~ /(.)\1{2}/) {
		my $t = $1;
		for(my $j = $i + 1; $j <= $i + 1000; $j++) {
			my $h2 = md5_hex($salt . $j);
			if(index($h2, $t x 5) >= 0) {
				push @out, [
					[$i, $h, $t],
					[$j, $h2]
				]
			}
		}
	}
	# if($i <= $last_quintuple) {
	# 	while($h =~ /(.)\1{4}/g) {
	# 			say "found: i=$i, t=$1, h=$h";
	# 			my @del;
	# 			for my $ti (0..@triples) {
	# 				my ($io, $to, $ho) = @{$triples[$ti]};
	# 				if($1 eq $to) {
	# 					push @out, [$io, $to, $ho];
	# 					say " n=${\(scalar @out)}, i=$io, t=$to, h=$ho";
	# 					push @del, $ti;
	# 					# exit if @out == 64;
	# 				}
	# 				drop_triple $_ for reverse @del;
	# 			}
	# 	}
	# }
	last if @out >= 64;
}
# say scalar @out;
my $n = 0;
for my $o (@out) {
	my ($f, $s) = @$o;
	my ($fi, $fh, $t) = @$f;
	my ($si, $sh) = @$s;
	# say $salt . $fi;
	# say $fh;
	die "wat" unless
		md5_hex($salt . $fi) == $fh &&
		index($fh, $t x 3) >= 0 &&
		$si - $fi <= 1000 &&
		md5_hex($salt . $si) == $sh &&
		index($sh, $t x 5) >= 0;
	# say "${\($n++)}: $fi, $si";
	say "${\($n++)} $fi $fh $si $sh";
}
# say Dumper(\@out);
