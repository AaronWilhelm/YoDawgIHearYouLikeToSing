#include "audio.h"
#include "global.h"

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

freq_ratio find_ratio(float current_freq)
{
    int index = NOTE_ARRAY_LENGTH - 1;
    int index_counter = (NOTE_ARRAY_LENGTH - 1) / 2;
    freq_ratio ratio;
    bool done = false;
    
    ratio.denominator = current_freq;
    while (!done)
    {
        //check to see if we are at the right frequency
        if( current_freq <= notes[index] && current_freq >= notes[index - 1])
        {
            done = true;
            break;
        }
        //if not, figure out whether to go higher or lower using binary search
        if ( current_freq > notes[index])
        {
            index += index_counter;
        } else
        {
            index -= index_counter;
        }
        //keep adding or subtracting diminishing powers of 2. 
        index_counter /= 2;
        //to prevent from accessing the nonexistant -1 element. 
        if( index == 1)
        {
            done = true;
            break;
        }
    }
    
    //we've now found a pitch probably between two accepted pitches so we
    //have to figure out which it is closer to
    if( current_freq > notes[index] - ((notes[index] - notes[index -1])/2))
        ratio.numerator = notes[index];
    else
        ratio.numerator = notes[index - 1];
    
    return ratio;
}

	
