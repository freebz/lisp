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

void describe_path(char **ret, const char* const edge[])
{
  char temp[1000] = "";
  sprintf(temp, "There is %s going %s from here.", edge[2], edge[1]);
  *ret = (char *)malloc(strlen(temp) * sizeof(char));
  strcpy(*ret, temp);
}

//한 번에 여러 경로 정의하기
void describe_paths(char **ret, const char *location, const Edge edges[])
{
  int i;
  char temp[1000] = "";
  char *buf;
  for (i=0; edges[i].location != NULL; i++) {
    if(strcmp(location, edges[i].location) == 0) {
      describe_path(&buf, edges[i].edge);
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
  *ret = (char *)malloc(strlen(temp) * sizeof(char));
  strcpy(*ret, temp);
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

void objects_at(const char ***ret, const char *loc, const char *objs[], const ObjectLocation obj_locs[]) {
  int i, j, ret_size = 0;
  const char *temp[1000];
  for (i=0; objs[i] != NULL; i++) {
    for (j=0; obj_locs[j].object != NULL; j++) {
      if(strcmp(objs[i], obj_locs[j].object) == 0
	 && strcmp(loc, obj_locs[j].location) == 0) {
	temp[ret_size++] = objs[i];
      }
    }
  }
  temp[ret_size++] = NULL;
  *ret = (const char **)malloc(ret_size * sizeof(const char **));
  for (i=0; i<ret_size; i++) {
    (*ret)[i] = temp[i];
  }
}

//눈에 보이는 물건 묘사하기
void describe_objects(char **ret, const char *loc, const char *objs[], const ObjectLocation obj_locs[])
{
  int i;
  char temp[1000] = "";
  const char **buf;
  objects_at(&buf, loc, objs, obj_locs);
  for(i=0; buf[i] != NULL; i++) {
    if (i == 0) {
      sprintf(temp, "You see a %s on the floor.", buf[i]);
    }
    else {
      sprintf(temp, "%s You see a %s on the floor.", temp, buf[i]);
    }
  }
  free(buf);
  *ret = (char *)malloc(strlen(temp) * sizeof(char *));
  strcpy(*ret, temp);
}

//전부 출력하기
char location[1000] = "living-room";

void look(char **ret)
{
  char temp[1000] = "";
  const char *node;
  char *paths, *objs;
  
  node = describe_location(location, nodes);
  describe_paths(&paths, location, edges);  
  describe_objects(&objs, location, objects, object_locations);
  
  strcpy(temp, node);
  strcat(temp, " ");
  strcat(temp, paths);
  strcat(temp, " ");
  strcat(temp, objs);
  
  free(paths);
  free(objs);
  
  *ret = (char *)malloc(strlen(temp) * sizeof(char *));
  strcpy(*ret, temp);
}

//게임 세계 둘러보기
void walk(char **ret, const char *direction)
{
  int i;
  for (i=0; edges[i].location != NULL; i++) {
    if (strcmp(edges[i].location, location) == 0
	&& strcmp(edges[i].edge[1], direction) == 0) {
      printf("%s\n", location);
      strcpy(location, edges[i].location);
      printf("%s\n", location);
      look(ret);
      return;
    }
  }
  char *fail = "You cannot go that way.";
  *ret = (char *)malloc(strlen(fail) * sizeof(char *));
  strcpy(*ret, fail);
}

void main()
{
  int i;
  const char *c_ret;
  char *ret;
  const char **cp_ret;
  
  
  c_ret = describe_location("living-room", nodes);
  printf("%s\n", c_ret);

  const char* edge[] = {"garden", "west", "door"};
  describe_path(&ret, edge);
  printf("%s\n", ret);
  free(ret);

  describe_paths(&ret, "living-room", edges);
  printf("%s\n", ret);
  free(ret);

  objects_at(&cp_ret, "living-room", objects, object_locations);
  for (i=0; cp_ret[i] != NULL; i++) {
    printf("%s ", cp_ret[i]);
  }
  printf("\n");
  free(cp_ret);

  describe_objects(&ret, "living-room", objects, object_locations);
  printf("%s\n", ret);
  free(ret);

  look(&ret);
  printf("%s\n", ret);
  free(ret);

 
  walk(&ret, "west");
  printf("%s\n", ret);
  free(ret);

 }
