#관련 풍경 묘사하기
nodes = {'living-room': "you are in the living-room. a wizard is snoring loudly on the couch.",
         'garden': "you are in a beautiful garden. there is a well in front of you.",
         'attic': "you are in the attic. there is a giant welding torch in the corner."}

#장소 묘사하기
def describe_location (location, nodes):
    return nodes[location]

#경로 묘사하기
edges = {'living-room': (('garden', 'west', 'door'),
                         ('attic', 'upstairs', 'ladder')),
         'garden': (('living-room', 'east', 'door'), ),
         'attic': (('living-room', 'downstairs', 'ladder'), )}

def describe_path (edge):
    return "there is a {0} going {1} from here.".format(edge[2], edge[1])

#한 번에 여러 경로 정의하기
def describe_paths (location, edges):
    return " ".join(map(describe_path, edges[location]))

#특정 장소의 물건 설명하기
#눈에 보이는 물건 나열하기
objects = ('whiskey', 'bucket', 'frog', 'chain')
object_locations = {'whiskey': 'living-room',
                     'bucket': 'living-room',
                     'chain': 'garden',
                     'frog': 'garden'}

def objects_at (loc, objs, obj_locs):
    #return list(filter(lambda obj: obj_locs[obj] == loc, objs))
    return [obj for obj in objs if obj_locs[obj] == loc]


#눈에 보이는 물건 묘사하기
def describe_objects (loc, objs, obj_loc):
    return " ".join(map(lambda obj:
                        "you see a {0} on the floor.".format(obj)
                        , objects_at(loc, objs, obj_loc)))

#전부 출력하기
location = 'living-room'

def look ():
    retList = []
    retList.append(describe_location (location, nodes))
    retList.append(describe_paths (location, edges))
    retList.append(describe_objects (location, objects, object_locations))
    return " ".join(retList)

#게임 세계 둘러보기
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

#물건 집기
def pickup (object):
    if member(objects_at(location, objects, object_locations), object):
        object_locations[object] = 'body'
        return "you are now carrying the {0}".format(object)
    else:
        return "you cannot get that."

#보관함 확인하기
def inventory ():
    return "items- " + " ".join(objects_at('body', objects, object_locations))

#게임 엔진에 직접 만든 인터페이스 추가하기
#직접 만드는 REPL
def game_repl ():
    while True:
        print(eval(input()))

#종료 기능을 추가
def game_repl ():
    while True:
        cmd = game_read()
        if cmd == 'quit()': break
        print(game_eval(cmd))

#read 함수 직접 작성하기
def game_read ():
    cmd = input().split(' ', 1)
    if len(cmd) == 2:
        return "{0}('{1}')".format(cmd[0], cmd[1])
    else:
        return "{0}()".format(cmd[0])

#game-eval 함수 작성하기
allowed_commands = ['look', 'walk', 'pickup', 'inventory']

def game_eval (sexp):
    if member(allowed_commands, sexp.split("(")[0]):
        return eval(sexp)
    else:
        return "I do not know that command."

#game-print 함수 작성하기

#요소인치 검사하는 함수
def member (list, value):
    for item in list:
        if item == value:
            return True
    return False


if __name__ == '__main__':
    game_repl()
