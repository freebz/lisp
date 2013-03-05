#'베베 꼬인 도시'의 에지 정의하기

$congestion_city_nodes = nil
$congestion_city_edges = nil
$player_pos = nil
$visited_nodes = nil
$node_num = 30
$edge_num = 45
$worm_num = 3
$cop_odds = 15

#무작위로 에지 생성하기
def random_node
  rand($node_num) + 1
end

def edge_pair (a, b)
  unless a == b then
    [[a, b], [b, a]]
  end
end

def make_edge_list
  $edge_num.times.map {
    edge_pair random_node, random_node
  }.compact.flatten(1)
end

#loop 명령어로 반복문 만들기

#섬으로 고립되는 것 방지하기
def direct_edges (node, edge_list)
  edge_list.select { |x|
    x[0] == node
  }
end
    
def get_connected (node, edge_list)
  @visited = []
  @edge_list = edge_list
  def traverse (node)
    unless @visited.include?(node) then
      @visited.push(node);
      (direct_edges node, @edge_list).each do |edge|
        traverse edge[1]
      end
    end
  end
  traverse node
  @visited
end

def find_islands (nodes, edge_list)
  @islands = []
  @edge_list = edge_list
  def find_island (nodes)
    connected = get_connected nodes[0], @edge_list
    unconnected = nodes - connected
    @islands.push(connected)
    unless unconnected.empty? then
      find_island unconnected
    end
  end
  find_island nodes
  @islands
end

def connect_with_bridges (islands)
  ret = []
  if islands[1] then
    ret.push(edge_pair islands[0][0], islands[1][0])
    connect_with_bridges islands[1..-1]
  end
  ret.flatten(1)
end

def connect_all_islands (nodes, edge_list)
  connect_with_bridges(find_islands nodes, edge_list) + edge_list
end

#'베베 꼬인 도시'의 마지막 에지 만들기
def make_city_edges
  nodes = [1..$node_num]
  edge_list = connect_all_islands nodes, make_edge_list
  cops = edge_list.select{
    rand($cop_odds) == 0
  }
  add_cops (edges_to_alist edge_list), cops
end

def edges_to_alist (edge_list)
  edge_list.map{|edge|
    edge[0]
  }.uniq.map{|node1|
    [node1] + 
    (direct_edges node1, edge_list).uniq.map{|edge|
      [edge[1]]
    }
  }
end

def add_cops (edge_alist, edges_with_cops)
  edge_alist.map{|x|
    node1 = x[0]
    node1_edges = x[1..-1]
    [node1] +
    node1_edges.map{|edge|
      node2 = edge[0]
      unless ((edge_pair node1, node2) & edges_with_cops).empty? then
        [node2, :cops]
      else
        edge
      end
    }
  }
end

#'배배 꼬인 도시'의 노드 생성하기
def neighbors (node, edge_alist)
  edge_alist.detect{|edge|
    edge[0] == node
  }[1..-1].map{|edge|
    edge[0]
  }
end

def within_one (a, b, edge_alist)
  (neighbors a, edge_alist).include?(b)
end

