{
	v = $1
	while(v >= 9) {
		v = int(v / 3) - 2
		sum += v
	}
}
END {
	print sum
}
