#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE	1000

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

char *describe_location(const char *location, const Node nodes[]) {
  int i;
  char temp[BUFFER_SIZE] = "";
  for (i=0; nodes[i].location != NULL; i++) {
    if(strcmp(location, nodes[i].location) == 0) {
      strcpy(temp, nodes[i].desc);
      break;
    }
  }
  char *ret = (char *) malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
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

char *describe_path( const char* const edge[])
{
  char temp[BUFFER_SIZE] = "";
  sprintf(temp, "There is %s going %s from here.", edge[2], edge[1]);
  char *ret = (char *)malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}

//한 번에 여러 경로 정의하기
char *describe_paths(const char *location, const Edge edges[])
{
  int i;
  char temp[BUFFER_SIZE] = "";
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
  int i, j, ret_size = 0;
  const char *temp[BUFFER_SIZE];
  for (i=0; objs[i] != NULL; i++) {
    for (j=0; obj_locs[j].object != NULL; j++) {
      if(strcmp(objs[i], obj_locs[j].object) == 0
	 && strcmp(loc, obj_locs[j].location) == 0) {
	temp[ret_size++] = objs[i];
      }
    }
  }
  temp[ret_size++] = NULL;
  const char **ret = (const char **)malloc(ret_size * sizeof(const char *));
  for (i=0; i<ret_size; i++) {
    ret[i] = temp[i];
  }
  return ret;
}

//눈에 보이는 물건 묘사하기
char *describe_objects(const char *loc, const char *objs[], const ObjectLocation obj_locs[])
{
  int i;
  char temp[BUFFER_SIZE] = "";
  const char **buf;
  buf = objects_at(loc, objs, obj_locs);
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
char location[BUFFER_SIZE] = "living-room";

char *look()
{
  char temp[BUFFER_SIZE] = "";
  char *buf;
  buf = describe_location(location, nodes);
  strcpy(temp, buf);
  free(buf);
  
  buf = describe_paths(location, edges);  
  strcat(temp, " ");
  strcat(temp, buf);
  free(buf);
  
  buf = describe_objects(location, objects, object_locations);
  strcat(temp, " ");
  strcat(temp, buf);
  free(buf);
    
  char *ret = (char *)malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}

//게임 세계 둘러보기
char *walk(const char *direction)
{
  int i;
  for (i=0; edges[i].location != NULL; i++) {
    if (strcmp(edges[i].location, location) == 0
	&& strcmp(edges[i].edge[1], direction) == 0) {
      strcpy(location, edges[i].edge[0]);
      return look();
    }
  }
  char *fail = "You cannot go that way.";
  char *ret = (char *)malloc(strlen(fail) * sizeof(char));
  strcpy(ret, fail);
  return ret;
}

//물건 집기
void pickup(const char *object)
{
}

void main()
{
  int i;
  char *ret;
  const char **cp_ret;
  
  ret = describe_location("living-room", nodes);
  printf("%s\n", ret);
  free(ret);

  const char* edge[] = {"garden", "west", "door"};
  ret = describe_path(edge);
  printf("%s\n", ret);
  free(ret);

  ret = describe_paths("living-room", edges);
  printf("%s\n", ret);
  free(ret);

  cp_ret = objects_at("living-room", objects, object_locations);
  for (i=0; cp_ret[i] != NULL; i++) {
    printf("%s ", cp_ret[i]);
  }
  printf("\n");
  free(cp_ret);

  ret = describe_objects("living-room", objects, object_locations);
  printf("%s\n", ret);
  free(ret);
  
  ret = look();
  printf("%s\n", ret);
  free(ret);

  ret = walk("west");
  printf("%s\n", ret);
  free(ret);
 }
