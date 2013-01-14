---
layout: default
title: Wizard
description: Text 어드벤처게임 Wizard
---

###관련 풍경 묘사하기

<p>
우선 노드를 정의한다. 가능한 해시또는 리스트 구조를 이용해서 정의한다.
</p>

<p>
Lisp는 리스트형태로 정의된다.
Ruby, Python, Javascript, Java는 해시로 정의된다.
C는 여인을 포함한 배열로 정의했다.
</p>

<p>
Lisp, Ruby, Python, JavaScript 등은 비교적 쉽게 정의 할 수 있지만,
Java와 C는 정의하는데 좀 손이 많이 간다.
</p>

<p>
다음은 장소를 묘사하는 코드를 보자, 해시로 저장된 노드에서 값을 읽어오기만 하는 간단한 코드이다.<br />
해시를 지원하는 모든 언어가 간단하게 구현되지만, 배열로 처리한 C는 루프를 돌기 때문에  코드가 복잡해졌다.
노드가 많아지면 속도향상을 위해서 순차적인 배열접근이 아닌 해시로 구현해야 한다.
</p>

<p>
설명은 변경되지 않으므로 const char* 형으로 바로 리턴해도 되지만, 다른 함수들과 같은 로직으로 처리하기 위하여
동적 메모리를 할당하여 char * 형으로 반환하였다.
</p>

<li>Lisp</li>
<pre><code>;관련 풍경 묘사하기
(defparameter *nodes* '((living-room (you are in the living-room.
				      a wizard is snoring loudly on the couch.))
			 (garden (you are in a beautiful garden.
				      there is a well in front of you.))
			 (attic (you are in the attic.
				     there is a giant welding torch in the corner.))))

;장소 묘사하기
(defun describe-location (location nodes)
  (cadr (assoc location nodes)))
</code></pre>

<li>Ruby</li>
<pre><code>#관련 풍경 묘사하기
$nodes = {
  :living_room => :"you are in the living-room. a wizard is snoring loudly on the couch.",
  :garden => :"you are in a beautiful garden. there is a well in front of you.",
  :attic => :"you are in the attic. there is a giant welding torch in the corner."}

#장소 묘사하기
def describe_location (location, nodes)
  nodes[location]
end
</code></pre>

<li>Python</li>
<pre><code>#관련 풍경 묘사하기
nodes = {'living-room': "you are in the living-room. a wizard is snoring loudly on the couch.",
         'garden': "you are in a beautiful garden. there is a well in front of you.",
         'attic': "you are in the attic. there is a giant welding torch in the corner."}

#장소 묘사하기
def describe_location (location, nodes):
    return nodes[location]
</code></pre>

<li>Perl</li>
<pre><code>#관련 풍경 묘사하기
%nodes = ("living-room" => "You are in the living-room. a wizard is snoring loudly on the couch.",
	  garden => "You are in a beautiful garden. there is a well in front of you.",
	  attic => "You are in the attic. there is a giant welding torch in the corner.");

#장소 묘사하기
sub describe_location {
    my($location, %nodes) = @_;
    $nodes{$location};
}
</code></pre>

<li>JavaScript</li>
<pre><code>//관련 풍경 묘사하기
nodes = {'living-room': 'you are in the living-room. a wizard is snoring loudly on the couch.',
	 garden: 'you are in a beautiful garden. there is a well in front of you.',
	 attic: 'you are in the attic. there is a giant welding torch in the corner.'};

//장소 묘사하기
function describe_location (location, nodes) {
    return nodes[location];
}
</code></pre>

<li>Java</li>
<pre><code>//관련 풍경 묘사하기
private static HashMap&lt;String, String&gt; nodes = new HashMap&lt;String, String&gt;() {
  {
    put("living-room", "You are in the living-room. A wizard is snoring loudly on the couch.");
    put("garden", "You are in a beautiful garden. There is a well in front of you.");
    put("attic", "You are in the attic. There is a giant welding torch in the corner.");
  }		      		
};

// 장소 묘사하기
private static String describe_location(String location, HashMap&lt;String, String&gt;nodes) {
	return nodes.get(location);
}
</code></pre>

<li>C</li>
<pre><code>//관련풍경 묘사하기
typedef struct {
  const char *location;
  const char *desc;
} Node;

const Node nodes[] = {
  {"living-room", "You are in the living-room. A wizard is snoring loudly on the couch."},
  {"garden", "You are in a beautiful garden. There is a well in front of you."},
  {"attic", "You are in the attic. There is a giant welding torch in the corner."},
  {NULL, NULL}
};

//장소 묘사하기
char *describe_location(const char *location, const Node nodes[]) {
  int i;
  char temp[BUFFER_SIZE] = "";
  for (i=0; nodes[i].location != NULL; i++) {
    if(strcmp(location, nodes[i].location) == 0) {
      strcpy(temp, nodes[i].desc);
      break;
    }
  }
  char *ret = (char *) malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}
</code></pre>



<h3>경로 묘사하기</h3>

<p>
경로의 자료구조는 노드보다는 좀 복잡하다.
Lisp에서는 그냥 리스트로 자연스럽게 정의하였다. 경로가 2개인 거실이 다른 장소와 조금 다른 형태로 정의 되었음을 주의하자

</p>

<li>Lisp</li>
<pre><code>;경로 묘사하기
(defparameter *edges* '((living-room (garden west door)
			 (attic upstairs ladder))
			(garden (living-room east door))
			(attic (living-room downstairs ladder))))

(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))
	
;한 번에 여러 경로 정의하기
(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))
</code></pre>

<li>Ruby</li>
<pre><code>#경로 묘사하기
$edges = {
  :living_room => [[:garden, :west, :door],
                   [:attic, :upstairs, :ladder]],
  :garden => [[:living_room, :east, :door]],
  :attic => [[:living_room, :downstairs, :ladder]]}

def describe_path (edge)
  "there is a #{edge[2]} going #{edge[1]} from here."
end

#한 번에 여러 경로 정의하기
def describe_paths (location, edges)
  edges[location].map{|edge|
    describe_path(edge)
  }.join(" ")
end
</code></pre>

<li>Python</li>
<pre><code>#장소 묘사하기
def describe_location (location, nodes):
    return nodes[location]
</code></pre>

<li>Perl</li>
<pre><code>#장소 묘사하기
sub describe_location {
    my($location, %nodes) = @_;
    $nodes{$location};
}
</code></pre>

<li>JavaScript</li>
<pre><code>//장소 묘사하기
function describe_location (location, nodes) {
  return nodes[location];
}
</code></pre>

<li>Java</li>
<pre><code>// 장소 묘사하기
private static String describe_location(String location, HashMap&lt;String, String&gt;nodes) {
  return nodes.get(location);
}
</code></pre>

<li>C</li>
<pre><code>//장소 묘사하기
char *describe_location(const char *location, const Node nodes[]) {
  int i;
  char temp[BUFFER_SIZE] = "";
  for (i=0; nodes[i].location != NULL; i++) {
    if(strcmp(location, nodes[i].location) == 0) {
      strcpy(temp, nodes[i].desc);
      break;
    }
  }
  char *ret = (char *) malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}
</code></pre>
