#ifndef AUDIO_H
#define AUDIO_H

#ifdef FOR_PC
  #include <sndfile.h>
  #include <stdio.h>
#endif

#ifdef FOR_DSP
#endif


#ifdef FOR_PC
struct audio_in_t
{
    char * file_name;
    SNDFILE * sf;
    SF_INFO info;
};
#endif

#ifdef FOR_DSP
struct audio_in_t
{
};
#endif


void init_audio_in(struct audio_in_t*);
void close_audio_in(struct audio_in_t*);

// Returns a 1/0 for if there is any more data to read
int fill_in_buffer(struct audio_in_t*, int * buffer, int size);



#endif /* AUDIO_H */
