#오크 대전 게임
#플레이어 전역변수와 몬스터 전역변수
$player_health = nil
$player_agility = nil
$player_strength = nil

$monsters = nil
$monster_builders = []
$monster_num = 12

#주요 게임 함수
def orc_battle
  init_monsters
  init_player
  game_loop
  if player_dead then
    puts "You have been killed. Game Over."
  end
  if monsters_dead then
    puts "Congratulations! You have vanquished all of your foes."
  end
end

def game_loop
  unless player_dead or monsters_dead
    show_player
    ([0, $player_agility].max / 15).floor.times{|k|
      unless monsters_dead
        show_monsters
        player_attack
      end
    }
    puts ""
    $monsters.each{|m|
      unless monster_dead m 
        m.attack
      end
    }
    game_loop
  end
end

#플레이어 관리 함수
def init_player
  $player_health = 30
  $player_agility = 30
  $player_strength = 30
end

def player_dead
  $player_health <= 0
end

def show_player
  print "You are a valiant knight with a health of "
  print $player_health
  print ", an agility of "
  print $player_agility
  print ", and a strength of "
  puts $player_strength
end

def player_attack
  print "Attack style: [s]tab [d]ouble swing [r]oundhouse:"
  case gets().chomp
  when "s"
    pick_monster.hit (randval $player_strength >> 1) + 2
  when "d"
    x = randval ($player_strength / 6).floor
    print "Your double swing has a strength of "
    puts x
    pick_monster.hit x
    unless monsters_dead
      pick_monster.hit x
    end
  else
    ((randval ($player_strength / 3).floor) +1).times{|x|
      unless monsters_dead
        random_monster.hit 1
      end
    }
  end
end

def randval (n)
  (rand [1, n].max) + 1
end

#플레이어 공격에 대한 핼퍼 함수
def random_monster
  @m = $monsters.sample
  if monster_dead @m
    random_monster
  end
  @m
end

def pick_monster
  print "Monster #:"
  x = gets().chomp.to_i
  if not (x.is_a? Integer and x >= 1 and x <= $monster_num)
    puts "Taht is not a valid monster number."
    pick_monster
  else
    m = $monsters[x -1]
    if monster_dead m
      puts "That monster is alread dead."
      pick_monster
    else
      m
    end
  end
end

#몬스터 관리 함수
def init_monsters
  $monsters = Array.new($monster_num){
    $monster_builders.sample.new
  }
end

def monster_dead (m)
  m.health <= 0
end

def monsters_dead
  $monsters.reject{|m|
    monster_dead m
  }.length == 0
end

def show_monsters
  puts "Your foes:"
  $monsters.each_with_index{|m, x|
    print "    "
    print x +1
    print ".  "
    if monster_dead m
      print "**dead**"
    else
      print "(Health="
      print m.health
      print ") "
      m.show
    end
    puts ""
  }   
end


#몬스터
#제네릭 몬스터

class Monster
  attr_reader :health

  def initialize
    @health = randval 10
  end

  def show
    print "A fierce "
    print self.class
  end

  def hit (x)
    @health -= x
    if monster_dead self
      print "You killed the "
      print self.class
      print "! "
    else
      print "You hit the "
      print self.class
      print ", knocking off "
      print x
      puts " health points!"
    end
  end

  def attack
  end
end



#사악한 오크
class Orc < Monster
  attr_reader :club_level
  
  def initialize
    super
    @club_level = randval 8
  end

  def show
    print "A wicked orc with a level "
    print @club_level
    print " club"
  end

  def attack
    x = randval @club_level
    print "An orc swing his club at you and knocks off "
    print x
    print " of your health points. "
    $player_health -= x
  end
end

$monster_builders << Orc

#악랄한 히드라
class Hydra < Monster
  
  def show
    print "A malicious hydra with "
    print @health
    print " heads."
  end

  def hit (x)
    @health -= x
    if monster_dead self
      puts "The corpes of the fully decapitated and decapacitated hydra falls to the floor! "
    else
      print "You lop off "
      print x
      puts " of the hydra's heads!"
    end
  end

  def attack
    x = (randval @health >> 1) -1
    print "A hydra attacks you with "
    print x
    print " of its heads! It also grow back one more head! "
    @health += 1
    $player_health -= x
  end
end

$monster_builders << Hydra

#퍼진 점균류
class SlimeMold < Monster
  
  def initialize
    super
    @sliminess = randval 5
  end

  def show
    print "A slime mold with a sliminess of "
    print @sliminess
  end

  def attack
    x = randval @sliminess
    print "A slime mold wraps around your legs and decreases your agility by "
    print x
    puts "!"
    $player_agility -= x
    if rand(2) == 0
      puts "It also squirts in your face, taking away a health point!"
      $player_health -= 1
    end
  end
end

$monster_builders << SlimeMold


#교할한 산적
class Brigand < Monster
  
  def attack
    x = [$player_health, $player_agility, $player_strength].max
    case x
    when $player_health
      puts "A brigand hits you with his slingshot, taking off 2 health points!"
      $player_health -= 2
    when $player_agility
      puts "A brigand catches your leg with his whip, taking off 2 agility points!"
      $player_agility -= 2
    when $player_strength
      puts "A brigand cuts your arm with his whip, taking off 2 strength points!"
      $player_strength -= 2
    end
  end
      
end

$monster_builders << Brigand
