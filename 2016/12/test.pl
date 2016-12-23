use feature 'say';
use Data::Dumper qw(Dumper);

my %registers;
# $registers{c} = 1;

sub get {
	my ($a) = @_;
	if($a =~ /^-?\d*$/) {
		return $a + 0;
	} else {
		return $registers{$a} + 0 || 0;
	}
}

my @instrs;

while(<>) {
	chomp $_;
	push @instrs, $_;
}

my $ip = 0;
while($ip <= $#instrs) {
	my $instr = $instrs[$ip];
	# say get("a") . " " . get("b") . " " . get("c") . " " . get("d");
	# say "$ip: $instr";
	if($instr =~ /^cpy (\S*) (\S*)$/) {
		$registers{$2} = get $1;
	} elsif($instr =~ /^jnz (\S*) (\S*)$/) {
		if(get($1) != 0) {
			$ip += get($2) - 1;
		}
	} elsif($instr =~ /^inc (\S*)$/) {
		$registers{$1}++;
	} elsif($instr =~ /^dec (\S*)$/) {
		$registers{$1}--;
	} else {
		die "Wat: $instr";
	}
	$ip++;
}
say get("a") . " " . get("b") . " " . get("c") . " " . get("d");
