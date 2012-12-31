use List::Util qw/first/;

#관련 풍경 묘사하기
%nodes = ("living-room" => "You are in the living-room. a wizard is snoring loudly on the couch.",
	  garden => "You are in a beautiful garden. there is a well in front of you.",
	  attic => "You are in the attic. there is a giant welding torch in the corner.");

#장소 묘사하기
sub describe_location {
    my($location, %nodes) = @_;
    $nodes{$location};
}

#경로 묘사하기
%edges = ("living-room" => [["garden", "west", "door"],
			    ["attic", "upstairs", "ladder"]],
	  garden => [["living-room", "east", "door"]],
	  attic => [["living-room", "downstairs", "ladder"]]);

sub describe_path {
    "There is a $_[0][2] going $_[0][1] from here."
}

#한 번에 여러 경로 정의하기
sub describe_paths {
    my($location, %edges) = @_;
    join " ", map{ &describe_path($_) } @{$edges{$location}};
}

#특정 장소의 물건 설명하기
#눈에 보이는 물건 나열하기
@objects = qw( whiskey bucket frog chain );
%object_locations = (whiskey => 'living-room',
		     bucket => 'living-room',
		     chain => 'garden',
		     frog => 'garden');

sub objects_at {
    my $loc = @_[0];
    my @objs = @{@_[1]};
    my %obj_locs = %{@_[2]};
    grep { $obj_locs{$_} eq $loc } @objs;
}

#눈에 보이는 물건 묘사하기
sub describe_objects {
    join " ", map { "You see a $_ on the floor." } objects_at(@_);
}

#전부 출력하기
$location = "living-room";

sub look {
    my @ret;
    push(@ret, describe_location ($location, %nodes));
    push(@ret, describe_paths ($location, %edges));
    push(@ret, describe_objects ($location, \@objects, \%object_locations));
    join " ", @ret;
}

#게임 세계 둘러보기
sub walk {
    my $direction = shift(@_);
    if (my $next = first { $_->[1] eq $direction } @{edges->{$location}}) {
	$location = $next->[0];
	&look;
    } else {
	"You cannot go that way.";
    }
}

#물건 집기
sub pickup {
    my $object = shift(@_);
    if (first { $_ eq $object } objects_at ($location, \@objects, \%object_locations)) {
	$object_locations{$object} = 'body';
	"You are now carrying the $object";
    } else {
	"You cannot get that.";
    }
}

#보관함 확인하기
sub inventory {
    my @items = objects_at ("body", \@objects, \%object_locations);
    "items- @items";
}

#게임 엔진에 직접 만든 인터페이스 추가하기
sub game_repl {
    while(<STDIN>) {
	chomp;
	print (eval $_);
	print "\n";
    }
}

#종료 기능을 추가
sub game_repl {
    while($_ = &game_read) {
	last if $_ eq "quit";
	print (game_eval($_));
	print "\n";
    }
}

#read 함수 직접 작성하기
sub game_read {
    chomp($_ = <STDIN>);
    my ($cmd, @param) = split;
    if (@param) {
	$cmd .= "('";
	$cmd .= join " ", @param;
	$cmd .= "')";
    }
    $cmd;
}

#game-eval 함수 작성하기
@allowed_commands = qw( look walk pickup inventory );

sub game_eval {
    my $sexp = shift(@_);
    my @cmd = split /\(/, $sexp;
    if (first { $_ eq $cmd[0] } @allowed_commands) {
	eval $sexp;
    } else {
	"I do not know that command.";
    }
}

&game_repl;
