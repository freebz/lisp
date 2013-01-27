var fs = require('fs');
var exec = require('child_process').exec;

//그래프 표현하기
wizard_nodes = {'living-room': 'you are in the living-room. a wizard is snoring loudly on the couch.',
		garden: 'you are in a beautiful garden. there is a well in front of you.',
		attic: 'you are in the attic. there is a giant welding torch in the corner.'};

wizard_edges = {'living-room': [['garden', 'west', 'door'],
				['attic', 'upstairs', 'ladder']],
		garden: [['living-room', 'east', 'door']],
		attic: [['living-room', 'downstairs', 'ladder']]};

//그래프 생성하기
//DOT 정보 생성하기
//노드 식별자 변환하기
function dot_name (exp) {
    return exp.replace(/\W/g, "_");
}

//그래프 노드에 이름표 추가하기
max_label_length = 30;

function dot_label (exp) {
    if (exp.length > max_label_length) {
	return exp.substr(0, max_label_length - 3) + "...";
    }
    else {
	return exp;
    }
}

//노드의 DOT 정보 생성하기
function nodes_to_dot (nodes) {
    for (var key in nodes) {
	process.stdout.write(dot_name(key));
	process.stdout.write("[label=\"");
	process.stdout.write(dot_label(nodes[key]));
	console.log("\"];");
    }
}

//에지를 DOT포맷으로 변환하기
function edges_to_dot (edges) {
    for (var node in edges) {
	for (var key in edges[node]) {
	    process.stdout.write(dot_name(node));
	    process.stdout.write("->");
	    process.stdout.write(dot_name(edges[node][key][0]));
	    process.stdout.write("[label=\"");
	    process.stdout.write(dot_label(edges[node][key].slice(1).join(" ")))
	    console.log("\"];");
	}
    }
}

//모든 DOT 데이터 생성하기
function graph_to_dot (nodes, edges) {
    console.log("digraph{");
    nodes_to_dot(nodes);
    edges_to_dot(edges);
    console.log("}");
}

//DOT 파일을 그림으로 바꾸기
function dot_to_png (fname, thunk) {
    var stdout = process.stdout;
    var fileStream = fs.createWriteStream(fname);
    process.__defineGetter__('stdout', function() {
	return fileStream;
    });
    thunk();
    process.__defineGetter__('stdout', function() {
	return stdout;
    });
    exec("dot -Tpng -O " + fname);
}

//명령창 결과 전송하기

//그래프를 그림으로 만들기
function graph_to_png (fname, nodes, edges) {
    var nodes = nodes;
    var edges = edges;
    dot_to_png(fname, function() {
	graph_to_dot(nodes, edges);
    });
}

//무향 그래프 생성하기
function uedges_to_dot (edges) {
    lst = [];
    for (var key in edges) {
	lst.push(key);
    }
    while (lst.length > 0) {
	var key = lst.shift();
	for (var edge in edges[key]) {
	    if(lst.indexOf(edges[key][edge][0]) == -1) {
		process.stdout.write(dot_name(key));
		process.stdout.write("--");
		process.stdout.write(dot_name(edges[key][edge][0]));
		process.stdout.write("[label=\"");
		process.stdout.write(dot_label(edges[key][edge].slice(1).join(" ")));
		console.log("\"];");
	    }
	}
    }
}

function ugraph_to_dot (nodes, edges) {
    console.log("graph{");
    nodes_to_dot(nodes);
    uedges_to_dot(edges);
    console.log("}");
}

function ugraph_to_png (fname, nodes, edges) {
    var nodes = nodes;
    var edges = edges;
    dot_to_png(fname, function(){
	ugraph_to_dot(nodes, edges);
    });
}
