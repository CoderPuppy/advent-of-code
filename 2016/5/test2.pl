use feature 'say';
use Data::Dumper qw(Dumper);
use Digest::MD5 qw(md5_hex);

# my $salt = "abc";
my $salt = "abbhdwsy";

my @pass;
for my $i (0..7) {
	$pass[$i] = " ";
}
my $filled = 0;

$| = 1;

sub write_out {
	print "[" . join("", @pass) . "] ";
}

write_out;
for(my $i = 0; $filled < 8; $i++) {
	my $h = md5_hex($salt . $i);
	if($h =~ /^0{5}(\d)(.)/ && $pass[$1] eq " ") {
		$filled++;
		$pass[$1] = $2;
		say "found a hash: $h: [$1] = $2 ($filled/8)";
		write_out;
	}
}
say "done";
