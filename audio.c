#include "audio.h"

#ifdef FOR_PC
void init_audio_in(struct audio_in_t* in)
{
    in->sf = sf_open(in->file_name, SFM_READ, &in->info);

    if( in->sf == NULL )
    {
        printf("Failed to open file\n");
    }

}

void close_audio_in(struct audio_in_t* in)
{
    sf_close(in->sf);
}


int fill_in_buffer(struct audio_in_t* in, int * buffer, int size)
{
    sf_count_t out;
    out = sf_read_int(in->sf, buffer, (sf_count_t) size);
    return (out == (sf_count_t) size);
}
#endif /* FOR_PC */

#ifdef FOR_DSP

void close_audio_in(struct audio_in_t* in) {} // Do nothing

#endif /* FOR_DSP */
