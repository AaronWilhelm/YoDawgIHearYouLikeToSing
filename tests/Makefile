OUTPUTS= audio

TARGET=PC
include ../pc.mk

.phony: clean

audio: test_audio.c ../audio.h ../audio.c
	$(CC) $(CFLAGS) test_audio.c ../audio.c -o $@

clean:
	rm *.o $(OUTPUTS) *~
