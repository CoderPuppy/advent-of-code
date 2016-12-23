use feature 'say';
use Data::Dumper qw(Dumper);
use Digest::MD5 qw(md5_hex);

# my $salt = "abc";
my $salt = "abbhdwsy";

my $pass = "";

for(my $i = 0; length($pass) < 8; $i++) {
	my $h = md5_hex($salt . $i);
	if($h =~ /^0{5}/) {
		say "found a hash: $pass: $h";
		$pass = $pass . substr($h, 5, 1);
	}
}
say $pass;
