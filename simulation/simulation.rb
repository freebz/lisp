#Simulated evolution: wherein bugs Learn to hunt bacteria.
#LOOP�� �Ἥ ��ȭ����

$width = 100
$height = 30
$jungle = [45, 10, 10, 10]
$plant_energy = 80

#���� ���� �� �Ĺ��� ����
require 'set'
$plants = Set.new

def random_plant left, top, width, height
  pos = [left + (rand width), top + (rand height)]
  $plants.add(pos)
end

def add_plants
  random_plant *$jungle
  random_plant 0, 0, $width, $height
end

#���� �����ϱ�
animal = Struct.new(:x, :y, :energy, :dir, :genes)

$animals = [].push(animal.new(($width >> 1) - 1,
                              ($height >> 1) - 1,
                              1000,
                              0,
                              Array.new(8){
                                (rand 10) + 1
                              }))


#������ ���� ó���ϱ�
def move animal
  dir = animal[:dir]
  x = animal[:x]
  y = animal[:y]
  animal[:x] = (x + ((dir >= 2 and dir <5)&& 1 ||
                     (dir == 1 and dir == 5)&& 0 ||
                     -1) + $width) % $width
  animal[:y] = (y + ((dir >= 0 and dir < 3)&& -1 ||
                     (dir >= 4 and dir < 7)&& 1 ||
                     0) + $height) % $height
  animal[:energy] -= 1
end

#������ ���� ��ȯ
def turn animal
  x = rand(animal[:genes].reduce{|x, y| x + y})
  def angle genes, x
    xnu = x - genes[0]
    if xnu < 0
      0
    else
      (angle genes[1..-1], xnu) + 1
    end
  end
  animal[:dir] = (animal[:dir] + angle(animal[:genes], x)) % 8
end

#������ ���� ����
def eat animal
  pos = [animal[:x], animal[:y]]
  if $plants.include? pos
    animal[:energy] += $plant_energy
    $plants.delete pos
  end
end

#������ ����
$reproduction_energy = 200

def reproduce animal
  e = animal[:energy]
  if e >= $reproduction_energy
    animal[:energy] = e >> 1
    animal_nu = animal.clone
    genes = animal[:genes].clone
    mutation = rand 8
    genes[mutation] = [1, genes[mutation] + (rand 3) - 1].max
    animal_nu[:genes] = genes
    $animals.push animal_nu
  end
end

#���� ������ �Ϸ�
def update_world
  $animals.reject!{|animal| animal[:energy] <= 0 }
  $animals.clone.each{|animal|
    turn animal
    move animal
    eat animal
    reproduce animal
  }
  add_plants
end

#���� ���� �׸���
def draw_world
  for y in 0...$height
    print "|"
    for x in 0...$width
      if $animals.detect{|animal|
          animal[:x] == x and animal[:y] == y
        }
        print "M"
      elsif $plants.include? [x, y]
        print "*"
      else
        print " "
      end
    end
    puts "|"
  end
end

#����� �������̽� �����
def evolution
  draw_world
  str = gets.chomp
  if str == "quit"
    nil
  else
    x = str.to_i
    if x != 0
      for i in 0...x
        update_world
        print "." if i % 1000 == 0
      end
      puts ""
    else
      update_world
    end
    evolution
  end
end
    
  
    
