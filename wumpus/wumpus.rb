#'���� ���� ����'�� ���� �����ϱ�

$congestion_city_nodes = nil
$congestion_city_edges = nil
$player_pos = nil
$visited_nodes = nil
$node_num = 30
$edge_num = 45
$worm_num = 3
$cop_odds = 15

#�������� ���� �����ϱ�
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

#loop ��ɾ�� �ݺ��� �����

#������ ���Ǵ� �� �����ϱ�
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
