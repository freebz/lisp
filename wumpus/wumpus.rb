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
  }.select{|edge| edge != nil}
end

#loop 명령어로 반복문 만들기

#섬으로 고립되는 것 방지하기
def direct_edges (node, edge_list)
  edge_list.select { |x|
    x[0][0] == node
  }
end
    
def get_connected (node, edge_list)
  @visited = []
  @edge_list = edge_list
  def traverse (node)
#    @visited.push(node)
    unless @visited.include?(node) then
      @visited.push(node);
      direct_edges node, edge_list
#      (direct_edges node, edge_list).each do |edge|
        #traverse edge[0][1]
#      end
    end
  end
  traverse node
  @visited
end
