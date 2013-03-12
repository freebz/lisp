var _ = require('./underscore');

// 관련 풍경 묘사하기
nodes = {'living-room': 'you are in the living-room. a wizard is snoring loudly on the couch.',
	 garden: 'you are in a beautiful garden. there is a well in front of you.',
	 attic: 'you are in the attic. there is a giant welding torch in the corner.'};

// 장소 묘사하기
function describe_location (location, nodes) {
    return nodes[location];
}

// 경로 묘사하기
edges = {'living-room': [['garden', 'west', 'door'],
			 ['attic', 'upstairs', 'ladder']],
	 garden: [['living-room', 'east', 'door']],
	 attic: [['living-room', 'downstairs', 'ladder']]};

function describe_path (edge) {
    return "there is a " + edge[2] + " going " + edge[1] + " from here.";
}

//한 번에 여러 경로 정의하기
function describe_paths (location, edges) {
    _.map(edges[location], function(edge) {
	describe_path(edge);
    }).join(" ");
}
