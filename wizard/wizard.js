//���� ǳ�� �����ϱ�
nodes = {'living-room': 'you are in the living-room. a wizard is snoring loudly on the couch.',
	 garden: 'you are in a beautiful garden. there is a well in front of you.',
	 attic: 'you are in the attic. there is a giant welding torch in the corner.'};

//��� �����ϱ�
function describe_location (location, nodes) {
    return nodes[location];
}

//��� �����ϱ�
edges = {'living-room': [['garden', 'west', 'door'],
			 ['attic', 'upstairs', 'ladder']],
	 garden: [['living-room', 'east', 'door']],
	 attic: [['living-room', 'downstairs', 'ladder']]};

function describe_path (edge) {
    return "there is a " + edge[2] + " going " + edge[1] + " from here.";
}

//�� ���� ���� ��� �����ϱ�
function describe_paths (location, edges) {
    var retList = [];
    for (var i in edges) {
	retList.push(describe_path (edges[i]));
    }
    return retList.join(" ");
}

//Ư�� ����� ���� �����ϱ�
//���� ���̴� ���� �����ϱ�
objects = ['whiskey', 'bucket', 'frog', 'chain'];
object_locations = {whiskey: 'living-room',
		    bucket: 'living-room',
		    chain: 'garden',
		    frog: 'garden'};

function objects_at (loc, objs, obj_locs) {
    var retList = [];
    for (var i in objs) {
	if(obj_locs[objs[i]] == loc) {
	    retList.push(objs[i]);
	}
    }
    return retList;
}

//���� ���̴� ���� �����ϱ�
function describe_objects (loc, objs, obj_loc) {
    var retList = [];
    for (var i in objs) {
	retList.push("you see a " + objs[i] + " on the floor.");
    }
    return retList.join(" ");
}

//���� ����ϱ�
location = 'living-room';

function look () {
    var retList = [];
    retList.push(describe_location (location, nodes));
    retList.push(describe_paths (location, edges));
    retList.push(describe_objects (location, objects, object_locations));
    return retList.join(" ");
}

//���� ���� �ѷ�����
function walk (direction) {
    var result = null;
    for (var i in edges[location]) {
	if (edges[location][i][1] == direction) {
	    result = edges[location][i];
	    break;
	}
    }
    if (result) {
	location = result[0];
	return look();
    }
    else {
	return "You cannot go that way.";
    }
}

//���� ����
function pickup (object) {
    if (member(object, objects_at(location, objects, object_locations))) {
	object_locations[object] = 'body';
	return "You are now carrying the " + object;
    }
    else {
	return "You cannot get that.";
    }
}

function member (value, list) {
    for (var i in list) {
	if (list[i] == value) {
	    return true;
	}
    }
    return false;
}

//������ Ȯ���ϱ�
function inventory () {
    return "items- " + objects_at("body", objects, object_locations);
}

//���� ������ ���� ���� �������̽� �߰��ϱ�
//���� ����� REPL
function game_repl () {
    while (true) {
	