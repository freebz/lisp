#�׷��� ǥ���ϱ�
%wizaqrd_nodes = ("living-room" => "You are in the living-room. A wizard is snoring loudly on the courch.",
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
    "Test"
}

print &dot_name();
