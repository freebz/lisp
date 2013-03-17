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

$animals = [].push(animal.new($width >> 1 - 1,
                              $height >> 1 - 1,
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

