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
  [player, board, (add_passing_move
                   board,
                   player,
                   spare_dice,
                   first_move,
                   (attacking_moves board, player, spare_dice))]
end

#���� �ѱ��
def add_passing_move board, player, spare_dice, first_move, moves
  if first_move
    moves
  else
    ret = []
    ret.push(nil)
    ret.push(game_tree (add_new_dice, board, player, spare_dice -1)
             , (player +1) % $num_players
             , 0
             , true)
  end
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
