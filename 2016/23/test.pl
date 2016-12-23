use feature 'say';
use Data::Dumper qw(Dumper);

my %registers;
# $registers{a} = 12;
$registers{a} = 7;

sub get {
	my ($a) = @_;
	if($a =~ /^-?\d*$/) {
		return $a + 0;
	} else {
		return $registers{$a} + 0 || 0;
	}
}

sub i_cpy {
	my ($src, $dst) = @_;
	$registers{$dst} = get $src;
}

sub i_jnz {
	
}

my @instrs;

while(<>) {
	push @instrs, [split " ", $_];
}

my $ip = 0;
while($ip <= $#instrs) {
	if($ip <= $#instrs - 2 && $instrs[$ip]->[0] eq "inc" && $instrs[$ip + 1]->[0] eq "dec" && $instrs[$ip + 2]->[0] eq "jnz" && $instrs[$ip + 2]->[1] eq $instrs[$ip + 1]->[1] && $instrs[$ip + 2]->[2] == -2 && get($instrs[$ip + 1]->[1]) >= 0) {
		$ip += 3;
		$registers{$instrs[$ip]->[1]} += $registers{$instrs[$ip + 1]->[1]};
		$registers{$instrs[$ip + 1]->[1]} = 0;
		next;
	}
	my @instr = @{$instrs[$ip]};
	# say get("a") . " " . get("b") . " " . get("c") . " " . get("d");
	# say "$ip: @instr";
	if($instr[0] eq "cpy") {
		$registers{$instr[2]} = get $instr[1];
	} elsif($instr[0] eq "jnz") {
		if(get($instr[1]) != 0) {
			$ip += get($instr[2]);
			next;
		}
	} elsif($instr[0] eq "inc") {
		$registers{$instr[1]}++;
	} elsif($instr[0] eq "dec") {
		$registers{$instr[1]}--;
	} elsif($instr[0] eq "tgl") {
		my $ti = $instrs[$ip + get($instr[1])];
		if($ti) {
			# say "toggling " . ($ip + get($instr[1])) . ": @$ti";
			if(@$ti == 2) {
				if($ti->[0] eq "inc") {
					$ti->[0] = "dec";
				} else {
					$ti->[0] = "inc";
				}
			} elsif(@$ti == 3) {
				if($ti->[0] eq "jnz") {
					$ti->[0] = "cpy";
				} else {
					$ti->[0] = "jnz";
				}
			}
			# say "to @$ti";
		}
	} else {
		die "Wat: $instr[0]";
	}
	$ip++;
}
say get("a") . " " . get("b") . " " . get("c") . " " . get("d");
