$small = 1;
$big = 100;

sub guess_my_number {
	($small + $big) >> 1 
}

sub smaller {
	$big = &guess_my_number - 1;
	guess_my_number;
}

sub bigger {
	$small = &guess_my_number + 1;
	guess_my_number;
}

sub start_over {
	$small = 1;
	$big = 100;
	guess_my_number;
}
