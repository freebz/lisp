#'베베 꼬인 도시'의 에지 정의하기

load "graph-util.rb"

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
  if islands[1] then
    (edge_pair islands[0][0], islands[1][0]).
      concat(connect_with_bridges islands[1..-1])
  else
    []
  end
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
  edge = edge_alist.detect{|edge|
    edge[0] == node
  }
  if edge then
    edge[1..-1].map{|edge|
      edge[0]
    }
  else
    []
  end
end

def within_one (a, b, edge_alist)
  (neighbors a, edge_alist).include?(b)
end

def within_two (a, b, edge_alist)
  within_one a, b, edge_alist ||
    ((neighbors a, edge_alist).map{|x|
       within_one x, b, edge_alist
     }.include?(true))
end

def make_city_nodes (edge_alist)
  wumpus = random_node
  glow_worms = Array.new($worm_num){ random_node }
  (1..$node_num).map{|n|
    [n]
    .concat(case
            when n == wumpus
              [:wumpus]
            when within_two(n, wumpus, edge_alist)
              [:blood!]
            else
              []
            end)
    .concat(case
            when glow_worms.include?(n)
              [:glow_worm]
            when glow_worms.detect{|worm|
                within_one n, worm, edge_alist
              }
              [:lights!]
            else
              []
            end)
    .concat(begin
              edge = edge_alist.detect{|edge|
                edge[0] == n
              }
              if edge then
                edge = edge[1..-1].detect{|edge|
                  edge[1]
                }
                if edge then
                  [:sirens!]
                else
                  []
                end
              else
                []
              end
            end)
  }
end

#대도둑 웜퍼스 게임 초기화하기
def new_game
  $congestion_city_edges = make_city_edges
  $congestion_city_nodes = make_city_nodes $congestion_city_edges
  $player_pos = find_empty_node
  $visited_nodes = [$player_pos]
  draw_city
  draw_known_city
end

def find_empty_node
  x = random_node
  if $congestion_city_nodes.detect{|node| node[0] == x}[1] then
    find_empty_node
  else
    x
  end
end

#도시 지도 그리기
def draw_city
  ugraph_to_png "city", $congestion_city_nodes, $congestion_city_edges
end

#부분적인 데이터로 도시 그릭
#드러난 노드
def known_city_nodes
  ($visited_nodes +
    ($visited_nodes.map{|node|
       $congestion_city_edges.assoc(node)[1..-1].map{|edge|
         edge[0]
       }
     }.flatten)).uniq.map{|node|
    if $visited_nodes.include?(node) then
      n = $congestion_city_nodes.assoc(node)
      if node == $player_pos then
        n + [:'*']
      else
        n
      end
    else
      [node] + ['?'.to_sym]
    end
  }
end

#드러난 에지
def known_city_edges
  $visited_nodes.map{|node|
    [node] +
    $congestion_city_edges.assoc(node)[1..-1].map{|x|
      if $visited_nodes.include?(x[0]) then
        x
      else
        [x[0]]
      end
    }
  }
end

#도시에서 드러난 부분만 그릭
def draw_known_city
  ugraph_to_png "known-city", known_city_nodes, known_city_edges
end

#도시 걸어다니기
def walk (pos)
  handle_direction pos, nil
end

def charge (pos)
  handle_direction pos, true
end

def handle_direction (pos, charging)
  edge = $congestion_city_edges.assoc($player_pos)[1..-1].assoc(pos)
  if edge then
    handle_new_place edge, pos, charging
  else
    puts "That location does not exist!"
  end
end

def handle_new_place (edge, pos, charging)
  node = $congestion_city_nodes.assoc(pos)
  has_worm = node.include?(:glow_worm) and not $visited_nodes.include?(pos)
  $visited_nodes.push(pos)
  $player_pos = pos
  draw_known_city
  case
  when edge.include?(:cops)
    puts "You ran into the cops. Game Over."
  when node.include?(:wumpus)
    if charging then
      puts "You found the Wumpus!"
    else
      puts "You ran into the Wumpus"
    end
  when charging
    new_pos = random_node
    print "You ran into a Glow Worm Gang! You're now at "
    puts new_pos
    handle_new_place [], new_pos, nil
  end
end
