SRC_DIR=../..
PLATFORM=PC

include $(SRC_DIR)/pc.mk

override CFLAGS += -I $(SRC_DIR)

C_FILES=main.c  \
        pvoc.c  \
        $(SRC_DIR)/fft.c

H_FILES=pvoc.h

.phony: clean

all: pvoc

pvoc: $(H_FILES) $(C_FILES)
	$(CC) $(CFLAGS) $(C_FILES) -o $@
	@echo "~~~~~~~~~~~~~~  BUILT ~~~~~~~~~~~~~~"

clean:
	-rm *~
