OUTPUTS= audio \
         fft

TARGET=PC
include ../pc.mk

.phony: clean $(OUTPUTS)

all: fft #$(OUTPUTS)

audio: test_audio.c ../audio.h ../audio.c
	$(CC) $(CFLAGS) test_audio.c ../audio.c -o $@
	./$@

fft: test_fft.c ../fft.h ../fft.c
	$(CC) $(CFLAGS) test_fft.c ../fft.c -o $@
	./$@

clean:
	rm *.o $(OUTPUTS) *~
