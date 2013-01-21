#���� ǳ�� �����ϱ�
nodes = {'living-room': "you are in the living-room. a wizard is snoring loudly on the couch.",
         'garden': "you are in a beautiful garden. there is a well in front of you.",
         'attic': "you are in the attic. there is a giant welding torch in the corner."}

#��� �����ϱ�
def describe_location (location, nodes):
    return nodes[location]

#��� �����ϱ�
edges = {'living-room': (('garden', 'west', 'door'),
                         ('attic', 'upstairs', 'ladder')),
         'garden': (('living-room', 'east', 'door'), ),
         'attic': (('living-room', 'downstairs', 'ladder'), )}

def describe_path (edge):
    return "there is a {0} going {1} from here.".format(edge[2], edge[1])

#�� ���� ���� ��� �����ϱ�
def describe_paths (location, edges):
    return " ".join(map(describe_path, edges[location]))

#Ư�� ����� ���� �����ϱ�
#���� ���̴� ���� �����ϱ�
objects = ('whiskey', 'bucket', 'frog', 'chain')
object_locations = {'whiskey': 'living-room',
                     'bucket': 'living-room',
                     'chain': 'garden',
                     'frog': 'garden'}

def objects_at (loc, objs, obj_locs):
    #return list(filter(lambda obj: obj_locs[obj] == loc, objs))
    return [obj for obj in objs if obj_locs[obj] == loc]


#���� ���̴� ���� �����ϱ�
def describe_objects (loc, objs, obj_loc):
    return " ".join(map(lambda obj:
                        "you see a {0} on the floor.".format(obj)
                        , objects_at(loc, objs, obj_loc)))

#���� ����ϱ�
location = 'living-room'

def look ():
    retList = []
    retList.append(describe_location (location, nodes))
    retList.append(describe_paths (location, edges))
    retList.append(describe_objects (location, objects, object_locations))
    return " ".join(retList)

#���� ���� �ѷ�����
def walk (direction):
    global location
    result = None
    for edge in edges[location]:
        if edge[1] == direction:
            result = edge
            break
    if result:
        location = result[0]
        return look()
    else:
        return "you cannot go that way."

#���� ����
def pickup (object):
    if member(objects_at(location, objects, object_locations), object):
        object_locations[object] = 'body'
        return "you are now carrying the {0}".format(object)
    else:
        return "you cannot get that."

#������ Ȯ���ϱ�
def inventory ():
    return "items- " + " ".join(objects_at('body', objects, object_locations))

#���ӿ� ���� ���� �������̽� �߰��ϱ�
#���� ����� REPL
def game_repl ():
    while True:
        print(eval(input()))

#
def game_repl ():
    while True:
        cmd = game_read()
        if cmd == 'quit()': break
        print(game_eval(cmd))

#read �Լ� ���� �ۼ��ϱ�
def game_read ():
    cmd = input().split(' ', 1)
    if len(cmd) == 2:
        return "{0}('{1}')".format(cmd[0], cmd[1])
    else:
        return "{0}()".format(cmd[0])

#game-eval �Լ� �ۼ��ϱ�
allowed_commands = ['look', 'walk', 'pickup', 'inventory']

def game_eval (sexp):
    if member(allowed_commands, sexp.split("(")[0]):
        return eval(sexp)
    else:
        return "I do not know that command."

#game-print �Լ� �ۼ��ϱ�

#�ɹ����� Ȯ���ϴ� �Լ�
def member (list, value):
    for item in list:
        if item == value:
            return True
    return False


if __name__ == '__main__':
    game_repl()
