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
  char *location;
} ObjectLocation;

ObjectLocation object_locations[] = {
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
char *pickup(const char *object)
{
  int i, j;
  char temp[BUFFER_SIZE] = "";
  const char **buf = objects_at(location, objects, object_locations);
  for (i=0; buf[i] != NULL; i++) {
    if(strcmp(object, buf[i]) == 0) {
      for (j=0; object_locations[j].object != NULL; j++) {
	if(strcmp(location, object_locations[j].location) == 0) {
	  object_locations[j].location = "body";
	  sprintf(temp, "You are now carrying the %s", object);
	  goto escapeLoop;
	}
      }
    }
  }
  strcpy(temp, "You cannot get that.");
 escapeLoop:
  free(buf);
  char *ret = (char *) malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}

//보관함 확인하기
char *inventory()
{
  int i;
  char temp[BUFFER_SIZE] = "items-";
  for (i=0; object_locations[i].object != NULL; i++) {
    if(strcmp(object_locations[i].location, "body") == 0) {
      strcat(temp, " ");
      strcat(temp, object_locations[i].object);
    }
  }
  char *ret = (char *) malloc(strlen(temp) * sizeof(char));
  strcpy(ret, temp);
  return ret;
}

//게임 엔진에 직접 만든 인터페이스 추가하기
//직접 만드는 REPL
//종료 기능을 추가
typedef struct {
  char cmd[BUFFER_SIZE];
  char param[BUFFER_SIZE];
} Command;

void game_read(Command *);
char *game_eval(const Command *);
void game_print(char*);

void game_repl()
{
  Command command;
  while(1) {
    game_read(&command);
    if (strcmp(command.cmd, "quit") == 0) {
      break;
    }
    else {
      game_print(game_eval(&command));
    }
  }
}

//read 함수 직접 작성하기
void game_read(Command *command)
{
  char cmd[BUFFER_SIZE];
  gets(cmd);

  char *p = strchr(cmd, ' ');
  if (p != NULL) {
    strncpy(command->cmd, cmd, p - cmd);
    strcpy(command->param, ++p);
  }
  else {
    strcpy(command->cmd, cmd);
    strcpy(command->param, "");
  }
}

//game-eval 함수 작성하기
typedef struct {
  const char *cmd;
  const void *fn;
  const int param;
} AllowedCommand;

const AllowedCommand allowed_command[] = {
  {"look", look, 0},
  {"walk", walk, 1},
  {"pickup", pickup, 1},
  {"inventory", inventory, 0},
  {NULL, NULL, 0}
};

char *game_eval(const Command *command)
{
  int i;
  for (i=0; allowed_command[i].cmd != NULL; i++) {
    if(strcmp(command->cmd, allowed_command[i].cmd) == 0) {
      if(allowed_command[i].param == 1) {
	return ((char*(*)(const char*))allowed_command[i].fn)(command->param);
      }
      else {
	return ((char*(*)())allowed_command[i].fn)();
      }
    }
  }
  char *fail = "I do not know that command.";
  char *ret = (char *) malloc(strlen(fail) * sizeof(char));
  strcpy(ret, fail);
  return ret;
}

//game-print 함수 작성하기
void game_print(char *result)
{
  printf("%s\n", result);
  free(result);
}

void main()
{
  game_repl();
}
