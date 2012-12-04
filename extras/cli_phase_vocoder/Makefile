SRC_DIR=../..
PLATFORM=PC

include $(SRC_DIR)/pc.mk

override CFLAGS += -I $(SRC_DIR)

C_FILES=main.c  \
        $(SRC_DIR)/pvoc.c  \
        $(SRC_DIR)/fft.c   \
        $(SRC_DIR)/audio.c

H_FILES=$(SRC_DIR)/pvoc.h \
        $(SRC_DIR)/fft.h  \
        $(SRC_DIR)/audio.h

.phony: clean

all: pvoc

pvoc: $(H_FILES) $(C_FILES)
	$(CC) $(CFLAGS) $(C_FILES) -o $@

clean:
	-rm *~
