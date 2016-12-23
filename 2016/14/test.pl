use feature 'say';
use Data::Dumper qw(Dumper);
use Digest::MD5 qw(md5_hex);

# my $salt = "cuanljph";

sub run {
	my ($salt, $num_keys, $fh_rep, $sh_rep, $sh_area) = @_;

	my @out;
	my %out_h;
	my @triples;
	my %relevant;
	my $last_quintuple = -1;
	my @lin_out;

	sub drop_triple {
		my ($n) = @_;
		my ($io, $to, $ho) = @{$triples[$n]};
		if($relevant{$to} == $io) {
			delete $relevant{$to};
		}
		splice @triples, $n, 1;
	}

	for(my $i = 0; @lin_out < $num_keys; $i++) {
		my $h = md5_hex($salt . $i);
		for my $hi (1..2016) {
			$h = md5_hex($h);
		}
		while(@triples && $triples[0]->[0] + $sh_area < $i) {
			drop_triple 0;
		}
		if($i <= $last_quintuple) {
			while($h =~ /(.)\1{${\($sh_rep - 1)}}/g) {
				if(defined $relevant{$1}) {
					my @del = ();
					for my $ti (0..@triples) {
						my $o = $triples[$ti];
						my ($io, $to, $ho) = @$o;
						if($1 eq $to) {
							push @out, $o;
							$out_h{$io} = $o;
							push @del, $ti;
						}
					}
					drop_triple $_ for reverse(@del);
				}
			}
		}
		if($h =~ /(.)\1{${\($fh_rep - 1)}}/) {
			push @triples, [$i, $1, $h];
			$relevant{$1} = $i;
			$last_quintuple = $i + $sh_area;
		}
		if(defined $out_h{$i - $sh_area}) {
			push @lin_out, $out_h{$i - $sh_area};
		}
	}
	@out = sort { $a->[0] <=> $b->[0] } @out;
	return \@lin_out;
}

my @norm_spec = (64, 3, 5, 1000);
my @uta_spec = ("yjdafjpo", 512, 4, 7, 100000);

my @out = @{run "cuanljph", @norm_spec};
my $i = 0;
for my $o (@out) {
	my ($i, $t, $h) = @$o;
	say "${\($n++)} $i $h";
}
