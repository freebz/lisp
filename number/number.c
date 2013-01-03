#include <stdio.h>

int small = 1;
int big = 100;

// guess-my-number 함수 정의하기
int guess_my_number () {
  return small + big >> 1;
}

// smaller와 bigger 함수 정의하기
int smaller () {
  big = guess_my_number() - 1;
  return guess_my_number();
}

int bigger () {
  small = guess_my_number() + 1;
  return guess_my_number();
}

// start-over 함수 정의하기
int start_over () {
  small = 1;
  big = 100;
  return guess_my_number();
}

void main() {
  char cmd[256];

  while(1) {
    gets(cmd);
    if (strcmp(cmd, "quit") == 0) {
      break;
    }
    else if (strcmp(cmd, "guess-my-number") == 0) {
      printf("%d\n", guess_my_number());
    }
    else if (strcmp(cmd, "bigger") == 0) {
      printf("%d\n", bigger());
    }
    else if (strcmp(cmd, "smaller") == 0) {
      printf("%d\n", smaller());
    }
    else if (strcmp(cmd, "start-over") == 0) {
      printf("%d\n", start_over());
    }
  }
}
