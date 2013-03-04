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
        traverse edge[0][1]
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
    connected.push(@islands)
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
    ret.push(edge_pair islands[0][0][0], islands[1][0][0])
    connect_with_bridges islands[1..-1]
  end
  ret
end

def connect_all_islands (nodes, edge_list)
  connect_with_bridges(find_islands nodes, edge_list) + edge_list
end

#'베베 꼬인 도시'의 마지막 에지 만들기
def make_city_edges
  nodes = [1..$node_num]
  edge_list = connect_all_islands nodes, make_edge_list
  coops = edge_list.select{
    rand($cop_odds) == 0
  }
  add_cops (edges_to_alist edge_list), cops
end

def edges_to_alist (edge_list)
  
