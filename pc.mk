CC=gcc
DEFINED_SYMBOLS=-DFOR_PC
UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
  LIBS = -L/opt/local/lib -lsndfile -lm
  INC_DIRS = -I/opt/local/include
endif

ifeq ($(UNAME), Linux)
  LIBS=-lsndfile
  INC_DIRS=
endif

LIBS=-lsndfile -lm
INC_DIRS=

CFLAGS=$(DEFINED_SYMBOLS) $(LIBS) $(INC_DIRS) -Wall
