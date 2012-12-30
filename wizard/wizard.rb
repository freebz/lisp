# -*- coding: euc-kr -*-
#���� ǳ�� �����ϱ�
$nodes = {
  :living_room => :"you are in the living-room.
a wizard is snoring loudly on the couch.",
  :garden => :"you are in a beautiful garden.
there is a well in front of you.",
  :attic => :"you are in the attic.
there is a giant welding torch in the corner."}

#��� �����ϱ�
def describe_location (location, nodes)
  nodes[location]
end

#��� �����ϱ�
$edges = {
  :living_room => [[:garden, :west, :door],
                   [:attic, :upstairs, :ladder]],
  :garden => [[:living_room, :east, :door]],
  :attic => [[:living_room, :downstairs, :ladder]]}

def describe_path (edge)
  "there is a #{edge[2]} going #{edge[1]} from here."
end

#�� ���� ���� ��� �����ϱ�
def describe_paths (location, edges)
  edges[location].map{|edge|
    describe_path(edge)
  }.join(" ")
end

#Ư�� ����� ���� �����ϱ�
#���� ���̴� ���� �����ϱ�
$objects = [:whiskey, :bucket, :frog, :chain]
$object_locations = {
  :whiskey => :living_room,
  :bucket => :living_room,
  :chain => :garden,
  :frog => :garden}

def objects_at (loc, objs, obj_locs)
  objs.select do |obj|
    obj_locs[obj] == loc
  end
end

#���� ���̴� ���� �����ϱ�
def describe_objects (loc, objs, obj_loc)
  objects_at(loc, objs, obj_loc).map{|obj|
    "you see a #{obj} on the floor."
  }.join(" ")
end

#���� ����ϱ�
$location = :living_room

def look
  retList = []
  retList.push(describe_location $location, $nodes)
  retList.push(describe_paths $location, $edges)
  retList.push(describe_objects $location, $objects, $object_locations)
  retList.join(" ")
end

#���� ���� �ѷ�����
def walk (direction)
  result = $edges[$location].detect{|edge| edge[1] == direction}
  if result then
    $location = result[0]
    look
  else
    :"you cannot go that way."
  end
end

#���� ����
def pickup (object)
  if (objects_at $location, $objects, $object_locations).include?(object) then
    $object_locations[object] = :body
    "you are now carrying the #{object}"
  else
    "you cannot get that."
  end
end

#������ Ȯ���ϱ�
def inventory
  'items- ' + (objects_at :body, $objects, $object_locations).join(" ")
end

#���� ������ ���� ���� �������̽� �߰��ϱ�
#���� ����� REPL
def game_repl ()
  while true do
    puts eval(gets)
  end
end

#���� ����� �߰�
def game_repl ()
  until (cmd = game_read) == 'quit' do
    puts game_eval(cmd)
  end
end

#read �Լ� ���� �ۼ��ϱ�
def game_read ()
  cmd = gets.chomp.split(/\s/, 2)
  if cmd.length == 2 then
    cmd[0] + " :" + cmd[1]
  else 
    cmd[0]
  end
end

#game-eval �Լ� �ۼ��ϱ�
$allowed_commands = ['look', 'walk', 'pickup', 'inventory'];

def game_eval (sexp)
  if $allowed_commands.include?(sexp.split(/\s/, 2)[0]) then
    eval(sexp)
  else
    :"I do not know that command."
  end
end

#game-print �Լ� �ۼ��ϱ�
