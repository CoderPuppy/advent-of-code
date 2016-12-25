use feature 'say';
use Data::Dumper qw(Dumper);
use IPC::Open3 qw(open3);

my @instrs;
while(<>) {
	push @instrs, [split " ", $_];
}

sub compile {
	my ($si, $sa, $sb, $sc, $sd) = @_;

	sub gen_reg {
		my ($r) = @_;
		if($r eq "a") {
			return "rbp";
		} elsif($r eq "b") {
			return "rbx";
		} elsif($r eq "c") {
			return "r12";
		} elsif($r eq "d") {
			return "r13";
		} else {
			die "Wat: $r";
		}
	}

	sub gen_val {
		my ($v) = @_;
		if($v =~ /^-?\d*$/) {
			return $v;
		} else {
			return gen_reg $v;
		}
	}

	sub gen_extern {
		my ($i) = @_;
		print "\tmov r14, $i\n";
		print "\tjmp ext\n";
	}

	print "section .data\n";
	print "\tfmt_ext: db \"extern %d\", 10, 0\n";
	print "\tfmt_st: db \"st %d %d %d %d\", 10, 0\n";
	print "\n";
	print "section .text\n";
	print "\tglobal main\n";
	print "\textern printf\n";
	print "\n";
	print "log_st:\n";
	print "\tmov rdi, fmt_st\n";
	print "\tmov rsi, rbp\n";
	print "\tmov rdx, rbx\n";
	print "\tmov rcx, r12\n";
	print "\tmov r8, r13\n";
	print "\txor rax, rax\n";
	print "\tcall printf\n";
	print "\tret\n";
	print "\n";
	print "ext:\n";
	print "\tcall log_st\n";
	print "\tmov rdi, fmt_ext\n";
	print "\tmov rsi, r14\n";
	print "\txor rax, rax\n";
	print "\tcall printf\n";
	print "\tjmp end\n";
	print "\n";
	print "main:\n";
	print "\tpush rbp\n";
	print "\tpush rbx\n";
	print "\tpush r12\n";
	print "\tpush r13\n";
	print "\tpush r14\n";
	print "\t\n";
	print "\tmov rbp, $sa\n";
	print "\tmov rbx, $sb\n";
	print "\tmov r12, $sc\n";
	print "\tmov r13, $sd\n";
	print "\t\n";
	print "\tcall log_st\n";
	print "\t\n";
	print "\tjmp i$si\n";
	print "\n";
	for my $i (0..$#instrs) {
		my @instr = @{$instrs[$i]};
		print "\t; ";
		print join " ", @instr;
		print "\n";
		print "i$i:\n";
		if($instr[0] eq "cpy") {
			print "\tmov ";
			print gen_reg $instr[2];
			print ", ";
			print gen_val $instr[1];
			print "\n";
		} elsif($instr[0] eq "dec" || $instr[0] eq "inc") {
			print "\t$instr[0] ";
			print gen_reg $instr[1];
			print "\n";
		} elsif($instr[0] eq "jnz") {
			if($instr[2] =~ /^-?\d*$/) {
				if($instr[1] =~ /^-?\d*$/) {
					next if $instr[1] == 0;
					print "\tjmp ";
				} else {
					print "\tcmp ";
					print gen_reg $instr[1];
					print ", 0\n";
					print "\tjne ";
				}
				print "i";
				print $i + $instr[2];
				print "\n";
			} else {
				gen_extern $i;
			}
		} elsif($instr[0] eq "tgl") {
			gen_extern $i;
		} else {
			die "Wat: $instr[0]";
		}
	}
	print "\t\n";
	print "end:\n";
	print "\tcall log_st\n";
	print "\tpop r14\n";
	print "\tpop r13\n";
	print "\tpop r12\n";
	print "\tpop rbx\n";
	print "\tpop rbp\n";
	print "\tret\n";
}

my $i = 0, $a = 12, $b = 0, $c = 0, $d = 0;

sub get {
	local $_ = shift;
	if($_ eq "a") {
		return $a;
	} elsif($_ eq "b") {
		return $b;
	} elsif($_ eq "c") {
		return $c;
	} elsif($_ eq "d") {
		return $d;
	} elsif(/^-?\d*$/) {
		return $_ + 0;
	} else {
		die "wat: $_";
	}
}

PARTS: while() {
	# say "go $i $a $b $c $d";
	my $fh;
	open($fh, ">", "test2.asm") or die "huh";
	select $fh;
	compile $i, $a, $b, $c, $d;
	close $fh;
	select STDOUT;
	system "nasm -f elf64 test2.asm";
	system "gcc test2.o -o test2";
	open(my $out, "./test2 |") or die "huh";
	LINES: while(<$out>) {
		if(/^st (-?\d*) (-?\d*) (-?\d*) (-?\d*)$/) {
			$a = $1 + 0;
			$b = $2 + 0;
			$c = $3 + 0;
			$d = $4 + 0;
		} elsif(/^extern (\d*)$/) {
			$i = $1 + 0;
			my @instr = @{$instrs[$i]};
			# say "ext $i (@instr) $a $b $c $d";
			if($instr[0] eq "tgl") {
				my $ti = $i + get($instr[1]);
				my $tin = $instrs[$ti];
				if($tin) {
					if(@$tin == 2) {
						if($tin->[0] eq "inc") {
							$tin->[0] = "dec";
						} else {
							$tin->[0] = "inc";
						}
					} elsif(@$tin == 3) {
						if($tin->[0] eq "jnz") {
							$tin->[0] = "cpy";
						} else {
							$tin->[0] = "jnz";
						}
					}
				}
				$i++;
			} elsif($instr[0] eq "jnz") {
				# say "jnz ${\(get($instr[1]))} ${\(get($instr[2]))}";
				if(get($instr[1]) != 0) {
					$i += get($instr[2]);
				}
			} else {
				die "wat: @instr";
			}
			close $out;
			next PARTS;
		} else {
			die "wat: $_";
		}
	}
	close $out;
	last;
}
say "done $a $b $c $d";
