#°ü·Ã Ç³°æ ¹¦»çÇÏ±â
%nodes = ("living-room" => "You are in the living-room. a wizard is snoring loudly on the couch.",
	  "garden" => "You are in a beautiful garden. there is a well in front of you.",
	  "attic" => "You are in the attic. there is a giant welding torch in the corner.");

#Àå¼Ò ¹¦»çÇÏ±â
sub describe_location {
    my($location, %nodes) = @_;
    $nodes{$location};
}

#°æ·Î ¹¦»çÇÏ±â
%edges = ("living-room" => [["garden", "west", "door"],
			    ["attic", "upstairs", "ladder"]],
	  "garden" => [["living-room", "east", "door"]],
	  "attic" => [["living-room", "downstairs", "ladder"]]);

sub describe_path {
    "There is a $_[0][2] going $_[0][1] from here."
}

sub describe_paths {
    my($location, %edges) = @_;
#    print $edges{$location}[0];
    my (@edges) = $edges{$location};
#    print $edges;
    for (@edges) {
	print "Loop\n";
#	print $edge, "\n";
    }
}

#print &describe_location('living-room', %nodes);
#print &describe_path (["garden", "west", "door"]);
&describe_paths ('living-room', %edges);

#print $edges->[0];
#print $edges{'living-room'}->[0]->[0];


#print "\n";
#print %edges;
#print %nodes;
