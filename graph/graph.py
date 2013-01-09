import re
import sys
import subprocess

#그래프 표현하기
wizard_nodes = {'living-room': "You are in the living-room. A wizard is snoring loudy on the couch.",
                'garden': "You are in a beautiful garden. There is a well in front of you.",
                'attic': "You are in the attic. There is a giant welding torch in the corner."}

wizard_edges = {'living-room': (('garden', 'west', 'door'),
                                ('attic', 'upstaairs', 'ladder')),
                'garden': (('living-room', 'east', 'door'), ),
                'attic': (('living-room', 'downstairs', 'ladder'), )}

#그래프 생성하기
#DOT 정보 새성하기
#노드 식별자 변환하기
def dot_name (exp):
    return re.sub("\W", "_", exp)

#그래프 노드에 이름표 추가하기
max_label_length = 30

def dot_label (exp):
    exp = str(exp)
    if len(exp) > max_label_length:
        return exp[:max_label_length-3] + "..."
    else:
        return exp

#노드의 DOT 정보 생성하기
def nodes_to_dot (nodes):
    for node in nodes:
        sys.stdout.write(dot_name(node))
        sys.stdout.write("[label=\"")
        sys.stdout.write(dot_label(nodes[node]))
        print("\"];")
        
#에지를 DOT포맷으로 변환하기
def edges_to_dot (edges):
    for node in edges:
        for edge in edges[node]:
            sys.stdout.write(dot_name(node))
            sys.stdout.write("->")
            sys.stdout.write(dot_name(edge[0]))
            sys.stdout.write("[label=\"")
            sys.stdout.write(dot_label(" ".join(edge[1:])))
            print("\"];");

#모든 DOT 데이터 생성하기
def graph_to_dot (nodes, edges):
    sys.stdout.write("digraph{")
    nodes_to_dot(nodes)
    edges_to_dot(edges)
    sys.stdout.write("}")

#DOT 파일을 그림으로 바꾸기
def dot_to_png (fname, thunk):
    f = open(fname, 'w')
    stdout = sys.stdout
    sys.stdout = f
    thunk()
    f.close()
    sys.stdout = stdout
    subprocess.call("dot -Tpng -O " + fname, shell=True)

#명령창 결과 전송하기

#그래프를 그림으로 만들기
def graph_to_png (fname, nodes, edges):
    dot_to_png(fname, lambda:
               graph_to_dot(nodes, edges))


    
