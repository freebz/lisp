use List::Util qw/first/;

#그래프 표현하기
%wizard_nodes = ("living-room" => "You are in the living-room. A wizard is snoring loudly on the courch.",
		  garden => "You are in a beautiful garden. There is a well in front of you.",
		  attic => "You are in the attic. There is a giant welding torch in the corner");

%wizard_edges = ("living-room" => [["garden", "west", "door"],
				   ["attic", "upstairs", "ladder"]],
		 garden => [["living-room", "east", "door"]],
		 attic => [["living-room", "downstairs", "ladder"]]);

#그래프 생성하기
#DOT 정보 생성하기
#노드 식별자 변환하기
sub dot_name {
    $_ = shift(@_);
    s/\W/_/;
    $_;
}

#그래프 노드에 이름표 추가하기
$max_label_length = 30;

sub dot_label {
    $_ = shift(@_);
    if (length($_) > $max_label_length) {
	substr($_, 0, $max_label_length - 3) . "...";
    } else {
	$_;
    }    
}

#노드의 DOT 정보 생성하기
sub nodes_to_dot {
    my %nodes = @_;
    while ( ($key, $node) = each %nodes) {
	print dot_name($key);
	print "[label=\"";
	print dot_label($node);
	print "\"];\n";
    }
}

#에지를 DOT포맷으로 변환하기
sub edges_to_dot {
    my %edges = @_;
    while ( my($key, $node) = each %edges) {
	for my $edge (@{$node}) {
	    print dot_name($key);
	    print "->";
	    print dot_name($edge->[0]);
	    print "[label=\"";
	    print dot_label(join " ", @{$edge}[1, -1]);
	    print "\"];\n";
	}
    }
}

#모든 DOT 데이터 생성하기
sub graph_to_dot {
    my %nodes = %{$_[0]};
    my %edges = %{$_[1]};
    print "digraph{\n";
    &nodes_to_dot(%nodes);
    &edges_to_dot(%edges);
    print "}";
}

#DOT 파일을 그림으로 바꾸기
sub dot_to_png {
    my ($fname, $thunk, $nodes, $edges) = @_;
    open FILE, ">", $fname;
    select FILE;
    &{$thunk}($nodes, $edges);
    select STDOUT;
    close FILE;
    system("dot -Tpng -O $fname");
}

#명령창 결과 전송하기

#그래프를 그림으로 만들기
sub graph_to_png {
    my $fname = $_[0];
    my %nodes = %{$_[1]};
    my %edges = %{$_[2]};
    &dot_to_png($fname, \&graph_to_dot, \%nodes, \%edges);
}

#무향 그래프 생성하기
sub uedges_to_dot {
    my %edges = @_;
    my @lst = keys %edges;
    while ($#lst >= 0) {
	my $key = shift(@lst);
	for my $edge (@{$edges{$key}}) {
	    unless (first { $_ eq $edge->[0] } @lst) {
		print dot_name($key);
		print "--";
		print dot_name($edge->[0]);
		print "[label=\"";
		print dot_label(join " ", @{$edge}[1, -1]);
		print "\"];\n";
	    }
	}
    }
}

sub ugraph_to_dot {
    my %nodes = %{$_[0]};
    my %edges = %{$_[1]};
    print "graph{\n";
    &nodes_to_dot(%nodes);
    &uedges_to_dot(%edges);
    print "}";
}

sub ugraph_to_png {
    my $fname = $_[0];
    my %nodes = %{$_[1]};
    my %edges = %{$_[2]};
    &dot_to_png($fname, \&ugraph_to_dot, \%nodes, \%edges);
}
