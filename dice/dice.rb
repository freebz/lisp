#����� �ֻ��� ���� ���� 1 �����ϱ�

#�������� �����ϱ�
$num_players = 2
$max_dice = 3
$board_size = 2
$board_hexnum = $board_size * $board_size

#������ �����ϱ�
def board_array lst
  lst
end

def gen_board ()
  Array.new($board_hexnum){
    [(rand $num_players), (rand $max_dice) +1]
  }
end

def player_letter n
  (n + 97).chr
end

def draw_board board
  for y in 0...$board_size
    puts ""
    ($board_size - y).times{
      print "  "
    }
    for x in 0...$board_size
      hex = board[x + ($board_size * y)]
      printf "%s-%s ", (player_letter hex[0]), hex[1]
    end
  end
end

#����� �ֻ��� ���� ��Ģ �и��ϱ�
#���� Ʈ�� �����ϱ�
def game_tree board, player, spare_dice, first_move
  [player, board].push(add_passing_move board, player, spare_dice, first_move,
                       (attacking_moves board, player, spare_dice))
end

#���� �ѱ��
def add_passing_move board, player, spare_dice, first_move, moves
  if first_move
    moves
  else
    pass = []
    pass.push(nil)
    pass.push(game_tree (add_new_dice board, player, spare_dice -1),
              (player +1) % $num_players,
              0,
              true)
    [pass] + moves
  end
end

#���� �̵� ����ϱ�
def attacking_moves board, cur_player, spare_dice
  #@board = board
  def player board, pos
    board[pos][0]
  end
  def dice board, pos
    board[pos][1]
  end
  
  (0...$board_hexnum).map{|src|
    if (player board, src)  == cur_player
      (neighbors src).map{|dst|
        if (player board, dst) != cur_player and (dice board, src) > (dice board, dst)
          [[src, dst]].push(game_tree (
                                       board_attack board, cur_player, src, dst, (dice board, src)),
                            cur_player, spare_dice + (dice board, dst), nil)
        end
      }
    end
  }.flatten(1).compact
end


#���� ���� ã��
def neighbors pos
  up = pos - $board_size
  down = pos + $board_size
  ret = [up, down]
  unless pos % $board_size == 0
    ret.push(up -1)
    ret.push(pos -1)
  end
  unless (pos +1) % $board_size == 0
    ret.push(pos +1)
    ret.push(down +1)
  end
  ret.select{|p|
    p >= 0 and p < $board_hexnum
  }
end

    
#����
def board_attack board, player, src, dst, dice
  board.each_with_index.map{|hex, pos|
    case
    when pos == src
      [player, 1]
    when pos == dst
      [player, dice - 1]
    else
      hex
    end
  }
end

#���� ����ϱ�
def add_new_dice board, player, spare_dice
  @player = player
  def f lst, n
    case
    when lst.empty?
      lst
    when n == 0
      lst
    else
      cur_player = lst[0][0]
      cur_dice = lst[0][1]
      if cur_player == @player and cur_dice < $max_dice
        [[cur_player, cur_dice +1]] + (f lst[1..-1], n -1)
      else
        [lst[0]] + (f lst[1..-1], n)
      end
    end
  end
  f board, spare_dice
end

#���ο� game_tree �Լ� ����ϱ�
#game_tree [[1,3],[1,1],[0,2],[1,1]], 0, 0, true

#�ٸ� ����� �ºٱ�

#�� �ݺ���
def play_vs_human tree
  print_info tree
  unless tree[2].empty?
    play_vs_human (handle_human tree)
  else
    announce_winner tree[1]
  end
end

#������ ���� ����
def print_info tree
  puts
  printf "current player = %s", (player_letter tree[0])
  draw_board tree[1]
end

#����� �Է°� ó���ϱ�
def handle_human tree
  puts
  puts "choose your move:"
  moves = tree[2]
  n = 0
  for move in moves
    n += 1
    action = move[0]
    printf "%d. ", n
    if action
      printf "%d -> %d\n", action[0], action[1]
    else
      puts "end turn"
    end
  end
  moves[(gets.chomp.to_i) -1][1]
end

#���� ������
def winners board
  tally = board.map{|hex|
    hex[0]
  }
  totals = tally.uniq.map{|player|
    [player, tally.count(player)]
  }
  best = totals.map{|x| x[1]}.max
  totals.select{|x|
    x[1] == best
  }.map{|x|
    x[0]
  }
end

def announce_winner board
  puts
  w = winners board
  if w.length > 1
    printf "The game is a tie between %s\n", w.map{|x| player_letter x }
  else
    printf "The winner is %s\n", (player_letter w[0])
  end
end
