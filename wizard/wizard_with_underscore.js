var _ = require('./underscore');

// ���� ǳ�� �����ϱ�
nodes = {'living-room': 'you are in the living-room. a wizard is snoring loudly on the couch.',
	 garden: 'you are in a beautiful garden. there is a well in front of you.',
	 attic: 'you are in the attic. there is a giant welding torch in the corner.'};

// ��� �����ϱ�
function describe_location (location, nodes) {
    return nodes[location];
}

// ��� �����ϱ�
edges = {'living-room': [['garden', 'west', 'door'],
			 ['attic', 'upstairs', 'ladder']],
	 garden: [['living-room', 'east', 'door']],
	 attic: [['living-room', 'downstairs', 'ladder']]};

function describe_path (edge) {
    return "there is a " + edge[2] + " going " + edge[1] + " from here.";
}

//�� ���� ���� ��� �����ϱ�
function describe_paths (location, edges) {
    _.map(edges[location], function(edge) {
	describe_path(edge);
    }).join(" ");
}
