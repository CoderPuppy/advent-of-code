use feature 'say';
use Data::Dumper qw(Dumper);

my %bots;
my %outputs;

sub get_bot {
	my ($id) = @_;
	if(defined $bots{$id}) {
		return $bots{$id};
	} else {
		my $bot = {
			type => "bot",
			id => $id,
			high => 0,
			low => 0,
			values => []
		};
		$bots{$id} = $bot;
		return $bot;
	}
}

sub get_output {
	my ($type, $id) = @_;
	if($type eq "bot") {
		return get_bot $id;
	} elsif($type eq "output") {
		if(defined $outputs{$id}) {
			return $outputs{$id};
		} else {
			my $output = {
				type => "output",
				id => $id,
				values => []
			};
			$outputs{$id} = $output;
			return $output;
		}
	} else {
		die "bad type: $type";
	}
}

while(<>) {
	if(/^value (\d*) goes to bot (\d*)$/) {
		my $bot = get_bot $2;
		push @{$bot->{values}}, $1;
	} elsif(/^bot (\d*) gives low to (bot|output) (\d*) and high to (bot|output) (\d*)$/) {
		my $bot = get_bot $1;
		$bot->{low} = get_output $2, $3;
		$bot->{high} = get_output $4, $5;
	} else {
		say "wat: ${\(Dumper($_))}";
	}
}

my @out;
sub send_ {
	my ($out, $val) = @_;
	# say $out->{type} . " " . $out->{id} . " <- " . $val;
	push @{$out->{values}}, $val;
	# say "hmm" if @{$out->{values}} > 2;
}
sub send_2 {
	my ($out, $val) = @_;
	# say $out->{type} . " " . $out->{id} . " <- " . $val;
	push @out, [$out, $val];
}

while() {
	for my $bid (keys %bots) {
		my $bot = $bots{$bid};
		if(@{$bot->{values}} >= 2) {
			my ($a, $b, @rest) = @{$bot->{values}};
			my ($low, $high) = sort { $a <=> $b } ($a, $b);
			say "$bid" if $low == 17 && $high == 61;
			# say "$bid" if $low == 2 && $high == 5;
			# if($low == 17 || $high == 17) {
			# 	say "$bid: $low, $high";
			# }
			# if($low == 61 || $high == 61) {
			# 	say "$bid: $low, $high";
			# }
			# say "bid: $bid, low: $low, high: $high, rest: " . join ",", @rest;
			$bot->{values} = \@rest;
			send_2 $bot->{low}, $low;
			send_2 $bot->{high}, $high;
		}
	}
	for my $o (@out) {
		# say $o->[0]->{type} . " " . $o->[0]->{id} . " <- " . $o->[1];
		send_ $o->[0], $o->[1];
	}
	last unless @out > 0;
	@out = ();
	# say "done";
}
