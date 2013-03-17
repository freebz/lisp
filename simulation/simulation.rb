#Simulated evolution: wherein bugs Learn to hunt bacteria.

#LOOP를 써서 진화하자

$width = 100
$height = 30
$jungle = [45, 10, 10, 10]
$plant_energy = 80

#게임 세계 속 식물의 성장
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

#동물 생성하기
animal = Struct.new(:x, :y, :energy, :dir, :genes)

$animals = [].push(animal.new($width >> 1 - 1,
                              $height >> 1 - 1,
                              1000,
                              0,
                              Array.new(8){
                                (rand 10) + 1
                              }))


#동물의 동작 처리하기
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

