#include "audio.h"

#ifdef FOR_PC
#include <stdlib.h>
// Input
void init_audio_in(struct audio_in_t* in)
{
    in->info.format = 0;
    in->sf = sf_open(in->file_name, SFM_READ, &in->info);

    if( in->sf == NULL )
    {
        printf("Failed to open input file\n");
        exit(1);
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

// Output
void init_audio_out(struct audio_out_t *out)
{
    out->info.format = SF_FORMAT_WAV | SF_FORMAT_PCM_16;
    out->info.samplerate = 44100;
    out->info.channels = 1;

    out->sf = sf_open(out->file_name, SFM_WRITE, &out->info);

    if(out->sf == NULL)
    {
        printf("Failed to open output file\n");
        printf(sf_strerror(out->sf));
        exit(2);
    }
}

void close_audio_out(struct audio_out_t *out)
{
    sf_close(out->sf);
}

int write_audio_buffer_float(struct audio_out_t *out, float* buffer, int size)
{
    sf_count_t amnt_written;
    amnt_written = sf_write_float(out->sf, buffer, (sf_count_t) size);
    return amnt_written == (sf_count_t) size;
}

#endif /* FOR_PC */

#ifdef FOR_DSP

void close_audio_in(struct audio_in_t* in) {} // Do nothing
void close_audio_out(struct audio_out_t* out) {} // Do nothing

#endif /* FOR_DSP */

float max_peak(float* fft_data, int length)
{
	float peak = 0;
	int index;
	int i;
	//assuming the fftw style data, we ignore the negative frequency area
 	//which is the second half of the fft data
	for(i = 0; i < length/2; i++)
	{
		if(fft_data[i] > peak)
		{
			index = i;
			peak = fft_data[i];
		}
	}

	//calculate the frequency from the index of the highest peak
	return (float)index * (SAMPLE_RATE / (float)length);
} 

	
