#운명의 주사위 게임 버전 1 구현하기

#전역변수 선언하기
$num_players = 2
$max_dice = 3
$board_size = 2
$board_hexnum = $board_size * $board_size

#게임판 구현하기
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

#운명의 주사위 게임 규칙 분리하기
#게임 트리 생성하기
def game_tree board, player, spare_dice, first_move
  [player, board].push(add_passing_move board, player, spare_dice, first_move,
                       (attacking_moves board, player, spare_dice))
end

#차례 넘기기
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

#공격 이동 계산하기
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


#인접 영역 찾기
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

    
#공격
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

#병력 충원하기
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

#새로운 game_tree 함수 사용하기
#game_tree [[1,3],[1,1],[0,2],[1,1]], 0, 0, true

#다른 사람과 맞붙기

#주 반복문
def play_vs_human tree
  print_info tree
  unless tree[2].empty?
    play_vs_human (handle_human tree)
  else
    announce_winner tree[1]
  end
end

#게임의 상태 정보
def print_info tree
  puts
  printf "current player = %s", (player_letter tree[0])
  draw_board tree[1]
end

#사람의 입력값 처리하기
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

#승자 가리기
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

#지능을 갖춘 적 만들기

#미니맥스 알고리즘을 실제 코드로 구현하기
def rate_position tree, player
  moves = tree[2]
  unless moves.empty?
    ratings = (get_ratings tree, player)
    if tree[0] == player
      ratings.max
    else
      ratings.min
    end
  else
    w = winners tree[1]
    if w.include?(player)
      1.0 / w.length
    else
      0
    end
  end
end

def get_ratings tree, player
  tree[2].map{|move|
    rate_position move[1], player
  }
end

#인공지능 플레이어와 함께 하는 게임 반복문 만들기
def handle_computer tree
  ratings = get_ratings tree, tree[0]
  tree[2][ratings.each_with_index.max[1]][1]
end

def play_vs_computer tree
  print_info tree
  case
  when tree[2].empty?
    announce_winner tree[1]
  when tree[0] == 0
    play_vs_computer (handle_human tree)
  else
    play_vs_computer (handle_computer tree)
  end
end



#운명의 주사위 게임 속도 개선하기

#메모이제이션

#neighbors 함수 메모이제이션하기
begin
  @old_neighbors = method(:neighbors)
  @previous_neighbors = Hash.new
  def neighbors pos
    @previous_neighbors[pos] or @previous_neighbors[pos] = (@old_neighbors.call pos)
  end
end


#게임 트리 메모이제이션
begin
  @old_game_tree = method(:game_tree)
  @previous_game_tree = Hash.new
  def game_tree *rest
    @previous_game_tree[rest] or @previous_game_tree[rest] = (@old_game_tree.call *rest)
  end
end

#rate_position 함수 메모이제이션
begin
  @old_rate_position = method(:rate_position)
  @previous_rate_position = Hash.new
  def rate_position tree, player
    tab = @previous_rate_position[player]
    unless tab
      tab = Hash[player, Hash.new]
    end
    tab[tree] or tab[tree] = (@old_rate_position.call tree, player)
  end
end
      


#꼬리 호출 최적화

#운명의 주사위 게임에서 꼬리 호출 최적화하기

#루비 1.9 이상에서 꼬리 호출 지원하기
RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

def add_new_dice board, player, spare_dice
  @player = player
  def f lst, n, acc
    case
    when n== 0
      acc + lst
    when lst.empty?
      acc
    else
      cur_player = lst[0][0]
      cur_dice = lst[0][1]
      if cur_player == @player and cur_dice < $max_dice
        f lst[1..-1], n -1, acc.push([cur_player, cur_dice +1])
      else
        f lst[1..-1], n, acc.push(lst[0])
      end
    end
  end
  f board, spare_dice, []
end


