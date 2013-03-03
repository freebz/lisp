#�׷��� ǥ���ϱ�
$wizard_nodes = {
  :living_room => :"You are in the living-room. A wizard is snoring loudly on the couch.",
  :garden => :"You are in a beautiful garden. There is a well in front of you.",
  :attic => :"You are in the attic. There is a giant welding torch in the corner."}

$wizard_edges = {
  :living_room => [[:garden, :west, :door],
                   [:attic, :upstairs, :ladder]],
  :garden => [[:living_room, :east, :door]],
  :attic => [[:living_room, :downstairs, :ladder]]
}

#�׷��� �����ϱ�
#DOT ���� �����ϱ�
#��� �ĺ��� ��ȯ�ϱ�
def dot_name (exp)
  exp = exp.to_s
  exp.gsub(/\W/, "_")
end

#�׷��� ��忡 �̸�ǥ �߰��ϱ�
$max_label_length = 30

def dot_label (exp)
  exp = exp.to_s
  if exp.length > $max_label_length then
    exp[0, $max_label_length - 3] + "..."
  else
    exp
  end
end

#����� DOT ���� �����ϱ�
def nodes_to_dot (nodes)
  nodes.map{|key, node|
    print dot_name key
    print "[label=\""
    print dot_label node
    puts "\"];"
  }
end

#������ DOT�������� ��ȯ�ϱ�
def edges_to_dot (edges)
  edges.map{|nodeKey, node|
    node.map{|edge|
      print dot_name nodeKey
      print "->"
      print dot_name edge[0]
      print "[label=\""
      print dot_label edge[1..-1].join(" ")
      puts "\"];"
    }
  }
end

#��� DOT ������ �����ϱ�
def graph_to_dot (nodes, edges)
  print "digraph{"
  nodes_to_dot nodes
  edges_to_dot edges
  print "}"
end

#DOT ������ �׸����� �ٲٱ�
def dot_to_png (fname, thunk)
  File.open(fname, "w"){|f|
    $stdout = f
    thunk.call
    $stdout = STDOUT
  }
  `dot -Tpng -O #{fname}`
end

#���â ��� �����ϱ�

#�׷����� �׸����� �����
def graph_to_png (fname, nodes, edges)
  dot_to_png fname, 
  lambda {
    graph_to_dot nodes, edges
  }
end

#���� �׷��� �����ϱ�
def uedges_to_dot (edges)
  lst = edges.keys
  until lst.empty? do
    key = lst.shift
    edges[key].each do |edge|
      if not lst.include? edge[0] then
        print dot_name key
        print "--"
        print dot_name edge[0]
        print "[label=\""
        print dot_label edge[1..-1].join(" ")
        puts "\"];"
      end
    end
  end
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
