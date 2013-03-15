#그래프 표현하기
$wizard_nodes = [
                 [:living_room, "You are in the living-room. A wizard is snoring loudly on the couch."],
                 [:garden, "You are in a beautiful garden. There is a well in front of you."],
                 [:attic, "You are in the attic. There is a giant welding torch in the corner."]
                ]

$wizard_edges = [
                 [:living_room, [:garden, :west, :door],
                  [:attic, :upstairs, :ladder]],
                 [:garden, [:living_room, :east, :door]],
                 [:attic, [:living_room, :downstairs, :ladder]]
                ]

#그래프 생성하기
#DOT 정보 생성하기
#노드 식별자 변환하기
def dot_name (exp)
  exp = exp.to_s
  exp.gsub(/\W/, "_")
end

#그래프 노드에 이름표 추가하기
$max_label_length = 30

def dot_label (exp)
  if exp.is_a?(Array) then
    exp = exp.join(" ")
  end
  exp = exp.to_s
  if exp.length > $max_label_length then
    exp[0, $max_label_length - 3] + "..."
  else
    exp
  end
end

#노드의 DOT 정보 생성하기
def nodes_to_dot (nodes)
  nodes.map{|node|
    print dot_name node[0]
    print "[label=\""
    print dot_label node
    puts "\"];"
  }
end

#에지를 DOT포맷으로 변환하기
def edges_to_dot (edges)
  edges.each{|node|
    node[1..-1].each{|edge|
      print dot_name node[0]
      print "->"
      print dot_name edge[0]
      print "[label=\""
      print dot_label edge[1..-1].join(" ")
      puts "\"];"
    }
  }
end

#모든 DOT 데이터 생성하기
def graph_to_dot (nodes, edges)
  puts "digraph{"
  nodes_to_dot nodes
  edges_to_dot edges
  print "}"
end

#DOT 파일을 그림으로 바꾸기
def dot_to_png (fname, thunk)
  File.open(fname, "w"){|f|
    $stdout = f
    thunk.call
    $stdout = STDOUT
  }
  `dot -Tpng -O #{fname}`
end

#명령창 결과 전송하기

#그래프를 그림으로 만들기
def graph_to_png (fname, nodes, edges)
  dot_to_png fname, 
  lambda {
    graph_to_dot nodes, edges
  }
end

#무향 그래프 생성하기
def uedges_to_dot (edges)
  edges.each_index{|index|
    lst = edges.drop(index)
    lst[0][1..-1].map{|edge|
      unless lst[1..-1].assoc(edge[0]) then
        print dot_name lst[0][0]
        print "--"
        print dot_name edge[0]
        print "[label=\""
        print dot_label edge[1..-1].join(" ")
        puts "\"];"
      end
    }
  }
end

def ugraph_to_dot (nodes, edges)
  print "graph{"
  nodes_to_dot nodes
  uedges_to_dot edges
  print "}"
end

def ugraph_to_png (fname, nodes, edges)
  dot_to_png fname,
  lambda {
    ugraph_to_dot nodes, edges
  }
end
