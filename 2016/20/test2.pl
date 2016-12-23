use feature 'say';
use List::Util qw(max);

# my $max = 30;
my $max = 4294967295;

my @things;
while(<>) {
	if(/^([^-\s]*)\-([^-\s]*)$/) {
		push @things, [$1, $2];
	}
}
@things = sort { @$a[0] <=> @$b[0] } @things;
my $last = -1;
my $n = 0;
my $bit;
say ~0;
for my $tr (@things) {
	# my @thing = (4, 10);
	my @thing = @$tr;
	# for my $i ($thing[0]..$thing[1]) {
	# 	vec($bit, $i, 1) = 1;
	# }
	print $last . ": " . $thing[0] . "-" . $thing[1] . "\n";
	if($thing[0] > $last + 1) {
		say "${\($last + 1)}-${\($thing[0] - 1)}: ${\($thing[0] - $last - 1)}";
		$n += $thing[0] - $last - 1;
		# say "HI!: " . ($last + 1);
		# last
	}
	$last = max($last, $thing[1]);
}
my $n2 = 0;
# for my $i (0..$max) {
# 	$n2++ if vec($bit, $i, 1) == 0;
# }
say "n2: $n2";
say "${\($last + 1)}-$max: ${\($max - $last)}";
$n += $max - $last;
say "n: $n";
# print(map { @$_[0] . "\n" } @things);
