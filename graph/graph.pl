#그래프 표현하기
%wizaqrd_nodes = ("living-room" => "You are in the living-room. A wizard is snoring loudly on the courch.",
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
    "Test"
}

print &dot_name();
