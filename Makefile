TARGET=auto_tuner
PLATFORM:= PC
C_FILES= main.c \
         fft.c  \
         audio.c

H_FILES= fft.h \
         audio.h

OBJS = ${C_FILES:.c=.o}

ifeq ($(PLATFORM),PC)
	include pc.mk
endif

ifeq ($(PLATFORM),DSP)
	include dsp.mk
endif

.phony: clean proper

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	-rm *~ $(OBJS)

proper: clean
