CC=gcc
DEFINED_SYMBOLS=-DFOR_PC
UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
  #Mac specific code
  LIBS = -L/opt/local/lib
  INC_DIRS = -I/opt/local/include
endif

ifeq ($(UNAME), Linux)
  #Linux specific code
  LIBS = 
  INC_DIRS = 
endif

#common code
override LIBS += -lsndfile -lm




CFLAGS=$(DEFINED_SYMBOLS) $(LIBS) $(INC_DIRS) -Wall
