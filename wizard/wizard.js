//관련 풍경 묘사하기
nodes = {'living-room': 'you are in the living-room. a wizard is snoring loudly on the couch.',
	 garden: 'you are in a beautiful garden. there is a well in front of you.',
	 attic: 'you are in the attic. there is a giant welding torch in the corner.'};

//장소 묘사하기
function describe_location (location, nodes) {
    return nodes[location];
}

//경로 묘사하기
edges = {'living-room': [['garden', 'west', 'door'],
			 ['attic', 'upstairs', 'ladder']],
	 garden: [['living-room', 'east', 'door']],
	 attic: [['living-room', 'downstairs', 'ladder']]};

function describe_path (edge) {
    return "there is a " + edge[2] + " going " + edge[1] + " from here.";
}

//한 번에 여러 경로 정의하기
function describe_paths (location, edges) {
    var retList = [];
    for (var i in edges) {
	retList.push(describe_path (edges[i]));
    }
    return retList.join(" ");
}

//특정 장소의 물건 설명하기
//눈에 보이는 물건 나열하기
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

//눈에 보이는 물건 묘사하기
function describe_objects (loc, objs, obj_loc) {
    var retList = [];
    for (var i in objs) {
	retList.push("you see a " + objs[i] + " on the floor.");
    }
    return retList.join(" ");
}

//전부 출력하기
location = 'living-room';

function look () {
    var retList = [];
    retList.push(describe_location (location, nodes));
    retList.push(describe_paths (location, edges));
    retList.push(describe_objects (location, objects, object_locations));
    return retList.join(" ");
}

//게임 세계 둘러보기
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

//물건 집기
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

//보관함 확인하기
function inventory () {
    return "items- " + objects_at("body", objects, object_locations);
}

//게임 엔진에 직접 만든 인터페이스 추가하기
//직접 만드는 REPL

var read = require('read');

function game_repl () {
    read({}, function (err, cmd) {
	console.log(eval(cmd));
	game_repl();
    });
}

//종료 기능을 추가
function game_repl () {
    game_read(function (cmd) {
	if (cmd != 'quit()') {
	    console.log(game_eval(cmd));
	    game_repl();
	}
    });
}

//read 함수 직접 작성하기
function game_read (callback) {
    read({}, function (err, cmd) {
	cmd = cmd.split(" ");
	if (cmd.length > 1) {
	    cmd = cmd[0] + "('" + cmd.splice(1).join(" ") + "')";
	}
	else {
	    cmd = cmd[0] + "()";
	}
	callback(cmd);
    });
}

allowed_commands = ['look', 'walk', 'pickup', 'inventory'];

function game_eval (sexp) {
    if (member(sexp.split("(")[0], allowed_commands)) {
	return eval(sexp);
    }
    else {
	return "I do not know that command.";
    }
};

game_repl();
