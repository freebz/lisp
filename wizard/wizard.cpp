#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <string>
#include <vector>

using namespace std;

//장소 묘사하기
typedef struct {
  const char *node;
  const char *desc;
} Node;

const Node nodes[] = {
  {"living-room", "You are in the living-room. A wizard is snoring loudly on the couch."},
  {"garden", "You are in a beautiful garden. There is a well in front of you."},
  {"attic", "You are in the attic. There is a giant welding torch in the corner."}
};

const char *describe_location(const char *location, const Node nodes[], const int size) {
  int i;
  for (i=0; i<size; i++) {
    if(strcmp(location, nodes[i].node) == 0) {
      return nodes[i].desc;
    }
  }
}

//경로 묘사하기
typedef struct {
  const char *node;
  const char *edge[3];
} Edge;

const Edge edges[] = {
  {"living-room", {"garden", "west", "door"}},
  {"living-room", {"attic", "upstairs", "ladder"}},
  {"garden", {"living-room", "east", "door"}},
  {"attic", {"living-room", "downstairs", "ladder"}} 
};

char *describe_path(const char* const edge[])
{
  const int templete_size = 27;
  int size = templete_size + strlen(edge[1]) + strlen(edge[2]);
  char *ret;
  ret = (char *)malloc(size * sizeof(char));
  sprintf(ret, "There is %s going %s from here.", edge[2], edge[1]);// edge[2], edge[1]);
  return ret;
}

//한 번에 여러 경로 정의하기
char *describe_paths(const char *location, const Edge edges[], const int size)
{
  int i, str_size = 0;
  char *ret;
  for (i=0; i<size; i++) {
    if(strcmp(location, edges[i].node) == 0) {
      char *path = describe_path(edges[i].edge);
      str_size = strlen(path) + str_size + 1;
      if(i == 0){
	ret = (char *)malloc(str_size * sizeof(char));
	strcpy(ret, path);
      }
      else {
	ret = (char *)realloc(ret, str_size * sizeof(char));
	strcat(ret, " ");
	strcat(ret, path);
      }
      free(path);
    }
  }
  return ret;
}

//특정 장소의 물건 설명하기
//눈에 보이는 물건 나열하기
const char *objects[] = {"whiskey", "bucket", "frog", "chain"};

typedef struct {
  const char *object;
  const char *node;
} ObjectLocation;

const ObjectLocation object_locations[] = {
  {"whiskey", "living-room"},
  {"bucket", "living-room"},
  {"chain", "garden"},
  {"frog", "garden"}
};

vector<const char *> objects_at(const char *loc, const char *objs[], const int objs_size,
		const ObjectLocation obj_locs[], const int obj_locs_size) {
  int i, j;
  vector<const char *> ret;
  for (i=0; i<objs_size; i++) {
    for (j=0; j<obj_locs_size; j++) {
      if(strcmp(objs[i], obj_locs[j].object) == 0
	 && strcmp(loc, obj_locs[j].node) == 0) {
	   ret.push_back(objs[i]);
      }
    }
  }
  return ret;
}

int main()
{
  const char *c_ret;
  char *ret;
  
  c_ret = describe_location("living-room", nodes, sizeof(nodes)/sizeof(nodes[0]));
  printf("%s\n", c_ret);

  const char* edge[] = {"garden", "west", "door"};
  ret = describe_path(edge);
  printf("%s\n", ret);  
  free(ret);

  ret = describe_paths("living-room", edges, sizeof(edges)/sizeof(edges[0]));
  printf("%s\n", ret);
  free(ret);

  vector<const char*> vc = objects_at("living-room", objects, sizeof(objects)/sizeof(objects[0]),
				      object_locations, sizeof(object_locations)/sizeof(object_locations[0]));
  

  // printf("%d\n", sizeof(nodes));
  //printf("%d\n", sizeof(nodes[0]));
  //printf("%d\n", sizeof(nodes) / sizeof(nodes[0]));

  return 0;
}
