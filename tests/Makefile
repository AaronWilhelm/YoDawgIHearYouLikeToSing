OUTPUTS= audio \
         fft

PLATFORM=PC
include ../pc.mk

.phony: clean

all: $(OUTPUTS)

audio: test_audio.c ../audio.h ../audio.c
	$(CC) $(CFLAGS) test_audio.c ../audio.c -o $@
	./$@

fft: test_fft.c ../fft.h ../fft.c
	$(CC) $(CFLAGS) test_fft.c ../fft.c -o $@
	./$@

clean:
	rm *.o $(OUTPUTS) *~
