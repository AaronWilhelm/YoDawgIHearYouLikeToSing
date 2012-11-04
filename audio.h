#ifndef AUDIO_H
#define AUDIO_H

#define SAMPLE_RATE 44100

#ifdef FOR_PC
  #include <sndfile.h>
  #include <stdio.h>
#endif

#ifdef FOR_DSP
  #include <csl.h>
#endif


#ifdef FOR_PC
struct audio_in_t
{
    char * file_name;
    SNDFILE * sf;
    SF_INFO info;
};

struct audio_out_t
{
    char * file_name;
    SNDFILE *sf;
    SF_INFO info;
};
#endif

static float notes [27] = {65.41, 73.42, 82.41, 87.31, 98, 110, 123.47, 130.81, 146.83, 164.81, 
	174.61, 196, 220, 246.94, 261.63, 293.66, 329.63, 349.23, 392, 440, 493.88,
	523.25, 587.33, 659.26, 698.46, 783.99, 880};

#ifdef FOR_DSP
struct audio_in_t
{
};
#endif

float max_peak(float* fft_data, int length);

void init_audio_in(struct audio_in_t*);
void close_audio_in(struct audio_in_t*);

void init_audio_out(struct audio_out_t *);
void close_audio_out(struct audio_out_t *);

// Returns a 1/0 for if there is any more data to read
int fill_in_buffer(struct audio_in_t*, int * buffer, int size);

// Returns 1 if the write went correctly
int write_audio_buffer_float(struct audio_out_t*, float*, int size);

#endif /* AUDIO_H */
