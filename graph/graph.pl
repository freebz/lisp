#�׷��� ǥ���ϱ�
%wizard_nodes = ("living-room" => "You are in the living-room. A wizard is snoring loudly on the courch.",
		  garden => "You are in a beautiful garden. There is a well in front of you.",
		  attic => "You are in the attic. There is a giant welding torch in the corner");

%wizard_edges = ("living-room" => [["garden", "west", "door"],
				   ["attic", "upstairs", "ladder"]],
		 garden => [["living-room", "east", "door"]],
		 attic => [["living-room", "downstairs", "ladder"]]);

#�׷��� �����ϱ�
#DOT ���� �����ϱ�
#��� �ĺ��� ��ȯ�ϱ�
sub dot_name {
    $_ = shift(@_);
    s/\W/_/;
    $_;
}

#�׷��� ��忡 �̸�ǥ �߰��ϱ�
$max_label_length = 30;

sub dot_label {
    $_ = shift(@_);
    if (length($_) > $max_label_length) {
	substr($_, 0, $max_label_length - 3) . "...";
    } else {
	$_;
    }    
}

#����� DOT ���� �����ϱ�
sub nodes_to_dot {
    my %nodes = @_;
    while ( ($key, $node) = each %nodes) {
	print dot_name($key);
	print "[label=\"";
	print dot_label($node);
	print "\"];\n";
    }
}

#������ DOT�������� ��ȯ�ϱ�
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

#print &dot_name("foo!");
#print &dot_label("1234567890ABCDEFGHIJKLMNOPWEWEDWE");
#&nodes_to_dot(%wizard_nodes);
&edges_to_dot(%wizard_edges);

#print $wizard_nodes{"living-room"};
