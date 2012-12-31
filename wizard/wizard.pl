use List::Util qw/first/;

#���� ǳ�� �����ϱ�
%nodes = ("living-room" => "You are in the living-room. a wizard is snoring loudly on the couch.",
	  garden => "You are in a beautiful garden. there is a well in front of you.",
	  attic => "You are in the attic. there is a giant welding torch in the corner.");

#��� �����ϱ�
sub describe_location {
    my($location, %nodes) = @_;
    $nodes{$location};
}

#��� �����ϱ�
%edges = ("living-room" => [["garden", "west", "door"],
			    ["attic", "upstairs", "ladder"]],
	  garden => [["living-room", "east", "door"]],
	  attic => [["living-room", "downstairs", "ladder"]]);

sub describe_path {
    "There is a $_[0][2] going $_[0][1] from here."
}

#�� ���� ���� ��� �����ϱ�
sub describe_paths {
    my($location, %edges) = @_;
    join " ", map{ &describe_path($_) } @{$edges{$location}};
}

#Ư�� ����� ���� �����ϱ�
#���� ���̴� ���� �����ϱ�
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

#���� ���̴� ���� �����ϱ�
sub describe_objects {
    join " ", map { "You see a $_ on the floor." } objects_at(@_);
}

#���� ����ϱ�
$location = "living-room";

sub look {
    my @ret;
    push(@ret, describe_location ($location, %nodes));
    push(@ret, describe_paths ($location, %edges));
    push(@ret, describe_objects ($location, \@objects, \%object_locations));
    join " ", @ret;
}

#���� ���� �ѷ�����
sub walk {
    my $direction = shift(@_);
    if (my $next = first { $_->[1] eq $direction } @{edges->{$location}}) {
	$location = $next->[0];
	&look;
    } else {
	"You cannot go that way.";
    }
}

#���� ����
sub pickup {
    my $object = shift(@_);
    if (first { $_ eq $object } objects_at ($location, \@objects, \%object_locations)) {
	$object_locations{$object} = 'body';
	"You are now carrying the $object";
    } else {
	"You cannot get that.";
    }
}

#������ Ȯ���ϱ�
sub inventory {
    my @items = objects_at ("body", \@objects, \%object_locations);
    "items- @items";
}

#���� ������ ���� ���� �������̽� �߰��ϱ�
sub game_repl {
    while(<STDIN>) {
	chomp;
	print (eval $_);
	print "\n";
    }
}

#���� ����� �߰�
sub game_repl {
    while($_ = &game_read) {
	last if $_ eq "quit";
	print (game_eval($_));
	print "\n";
    }
}

#read �Լ� ���� �ۼ��ϱ�
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

#game-eval �Լ� �ۼ��ϱ�
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
