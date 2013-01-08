#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//장소 묘사하기
typedef struct {
  const char *location;
  const char *desc;
} Node;

const Node nodes[] = {
  {"living-room", "You are in the living-room. A wizard is snoring loudly on the couch."},
  {"garden", "You are in a beautiful garden. There is a well in front of you."},
  {"attic", "You are in the attic. There is a giant welding torch in the corner."},
  {NULL, NULL}
};

const char *describe_location(const char *location, const Node nodes[]) {
  int i;
  for (i=0; nodes[i].location != NULL; i++) {
    if(strcmp(location, nodes[i].location) == 0) {
      return nodes[i].desc;
    }
  }
}

//경로 묘사하기
typedef struct {
  const char *location;
  const char *edge[3];
} Edge;

const Edge edges[] = {
  {"living-room", {"garden", "west", "door"}},
  {"living-room", {"attic", "upstairs", "ladder"}},
  {"garden", {"living-room", "east", "door"}},
  {"attic", {"living-room", "downstairs", "ladder"}},
  {NULL, {NULL, NULL, NULL}}
};

char *describe_path(const char* const edge[])
{
  const templete_size = 27;
  int size = templete_size + strlen(edge[1]) + strlen(edge[2]);
  char *ret;
  ret = (char *)malloc(size * sizeof(char));
  sprintf(ret, "There is %s going %s from here.", edge[2], edge[1]);
  return ret;
}

//한 번에 여러 경로 정의하기
char *describe_paths(const char *location, const Edge edges[])
{
  int i;
  char temp[1000] = "";
  for (i=0; edges[i].location != NULL; i++) {
    if(strcmp(location, edges[i].location) == 0) {
      char *buf = describe_path(edges[i].edge);
      if(i == 0){
	strcpy(temp, buf);
      }
      else {
	strcat(temp, " ");
	strcat(temp, buf);
      }
      free(buf);
    }
  }
  char *ret = (char *)malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}

//특정 장소의 물건 설명하기
//눈에 보이는 물건 나열하기
const char *objects[] = {"whiskey", "bucket", "frog", "chain", NULL};

typedef struct {
  const char *object;
  const char *location;
} ObjectLocation;

const ObjectLocation object_locations[] = {
  {"whiskey", "living-room"},
  {"bucket", "living-room"},
  {"chain", "garden"},
  {"frog", "garden"},
  {NULL, NULL}
};

const char **objects_at(const char *loc, const char *objs[], const ObjectLocation obj_locs[]) {
  int i, j, ret_size = 1;
  const char **ret = (const char **)malloc(ret_size * sizeof(const char *));
  for (i=0; objs[i] != NULL; i++) {
    for (j=0; obj_locs[j].object != NULL; j++) {
      if(strcmp(objs[i], obj_locs[j].object) == 0
	 && strcmp(loc, obj_locs[j].location) == 0) {
	ret = (const char **)realloc(ret, (ret_size + 1) *sizeof(const char *));
	ret[ret_size-1] = objs[i];
	ret_size++;
      }
    }
  }
  ret[ret_size-1] = NULL;
  return ret;
}

//눈에 보이는 물건 묘사하기
char *describe_objects(const char *loc, const char *objs[], const ObjectLocation obj_locs[])
{
  int i;
  char temp[1000] = "";
  const char **buf = objects_at(loc, objs, obj_locs);
  for(i=0; buf[i] != NULL; i++) {
    if (i == 0) {
      sprintf(temp, "You see a %s on the floor.", buf[i]);
    }
    else {
      sprintf(temp, "%s You see a %s on the floor.", temp, buf[i]);
    }
  }
  free(buf);
  char *ret = (char *)malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}

//전부 출력하기
char location[100] = "living-room";

char *look()
{
  const char *node = describe_location(location, nodes);
  char *path = describe_paths(location, edges);  
  char *objs = describe_objects(location, objects, object_locations);

  int ret_size = strlen(node) + strlen(path) + strlen(objs) + 2;
  char *ret = (char *)malloc(ret_size * sizeof(char));
  sprintf(ret, "%s %s %s", node, path, objs);
  free(path);
  free(objs);
  return ret;
}

//게임 세계 둘러보기
void walk(const char *direction)
{
  
}

void main()
{
  /*
  const char *c_ret;
  char *ret;
  const char **cp_ret;
  
  c_ret = describe_location("living-room", nodes, sizeof(nodes)/sizeof(nodes[0]));
  printf("%s\n", c_ret);

  const char* edge[] = {"garden", "west", "door"};
  ret = describe_path(edge);
  printf("%s\n", ret);  
  free(ret);

  ret = describe_paths("living-room", edges, sizeof(edges)/sizeof(edges[0]));
  printf("%s\n", ret);
  free(ret);

  cp_ret = objects_at("living-room", objects, sizeof(objects)/sizeof(objects[0]),
		      object_locations, sizeof(object_locations)/sizeof(object_locations[0]));
  printf("%s %s\n", cp_ret[0], cp_ret[1]);
  free(cp_ret);

 
  ret = describe_objects("living-room", objects, sizeof(objects)/sizeof(objects[0]),
		   object_locations, sizeof(object_locations)/sizeof(object_locations[0]));
  printf("%s\n", ret);
  free(ret);
  
  */
  char *ret;
  ret = look();
  printf("%s\n", ret);
  free(ret);
  
  //look();
  //look();
  
  // printf("%d\n", sizeof(nodes));
  //printf("%d\n", sizeof(nodes[0]));
  //printf("%d\n", sizeof(nodes) / sizeof(nodes[0]));
  
}
