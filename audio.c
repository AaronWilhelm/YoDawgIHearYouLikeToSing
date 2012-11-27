#include "global.h"
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
    int i;
    sf_count_t out;
    out = sf_read_int(in->sf, buffer, (sf_count_t) size);

    for(i = out; i < size; ++i)
    {
        buffer[i] = 0;
    }

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

float max_peak(struct complex_t* fft_data, int length)
{
	float peak = 0;
	int index;
	int i;
	float sample;
	//assuming the fftw style data, we ignore the negative frequency area
 	//which is the second half of the fft data
	for(i = 0; i < length/2 +1; i++)
	{
        	sample = (fft_data[i].real * fft_data[i].real) + (fft_data[i].imag * fft_data[i].imag);
		if(sample > peak)
		{
			index = i;
			peak = sample;
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
    int done = 0;
#ifdef VOICE
    current_freq /= 7; //assuming given max peak and finding ratio for voice signals. 
#endif    

    ratio.denominator = current_freq;
    while (!done)
    {
        //check to see if we are at the right frequency
        if( current_freq <= notes[index] && current_freq >= notes[index - 1])
        {
            done = 1;
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
            done = 1;
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

int upsample(float* o_data, float* n_data, int factor)
{
    float slope;
    int i,j;
    if (arraysize(n_data) < factor * arraysize(o_data)-(factor-1))
    {
        return -1;//return -1 is the new array isn't big enough
    }
    for(i = 0; i < arraysize(o_data) - 1;i++)
    {
        slope = (o_data[i] - o_data[i+1]) / factor;
        n_data[i*factor] = o_data[i];
        
        //linear interpolation
        for(j = 1; j < factor; j++)
        {
            n_data[(i*factor)+j] = o_data[i] + (j*slope);
        }
    }
    n_data[i*factor] = o_data[i];
    
    return (arraysize(o_data)*factor)-(factor-1);//return size of output data
}
	
int downsample(float* o_data, float* n_data, int factor)
{
    float average;
    int i,j;
    if (arraysize(n_data) < arraysize(o_data) / factor)
    {
        return -1;//return -1 is the new array isn't big enough
    }
    
    for(i = 0; i < arraysize(o_data) - factor; i+=factor)
    {
        average = 0;
        //average all samples to be included in the downsampled sample
        for(j = 0; j < factor; j++)
        {
            average += o_data[i+j];
        }
        average /= factor;
        n_data[i / factor] = average;
    }
    n_data[i*factor] = o_data[i];
    
    return (arraysize(o_data) / factor);//return size of output data
}

int upsample_c(struct complex_t* o_data, struct complex_t* n_data, int factor)
{
    float i_slope, q_slope;
    int i,j;
    if (arraysize(n_data) < factor * arraysize(o_data)-(factor-1))
    {
        return -1;//return -1 is the new array isn't big enough
    }
    for(i = 0; i < arraysize(o_data) - 1;i++)
    {
        i_slope = (o_data[i].real - o_data[i+1].real) / factor;
        q_slope = (o_data[i].imag - o_data[i+1].imag) / factor;
        
        n_data[i*factor].imag = o_data[i].imag;
        n_data[i*factor].real = o_data[i].real;
        //linear interpolation
        for(j = 1; j < factor; j++)
        {
            n_data[(i*factor)+j].real = o_data[i].real + (j*i_slope);
            n_data[(i*factor)+j].imag = o_data[i].imag + (j*q_slope);
        }
    }
    n_data[i*factor].real = o_data[i].real;
    n_data[i*factor].imag = o_data[i].imag;
    
    
    return (arraysize(o_data)*factor)-(factor-1);//return size of output data
}

int downsample_c(struct complex_t* o_data, struct complex_t* n_data, int factor)
{
    float i_average, q_average;
    int i,j;
    if (arraysize(n_data) < arraysize(o_data) / factor)
    {
        return -1;//return -1 is the new array isn't big enough
    }
    
    for(i = 0; i < arraysize(o_data) - factor; i+=factor)
    {
        i_average = 0;
        q_average = 0;
        //average all samples to be included in the downsampled sample
        for(j = 0; j < factor; j++)
        {
            i_average += o_data[i+j].real;
            q_average += o_data[i+j].imag;
        }
        i_average /= factor;
        q_average /= factor;
        
        n_data[i / factor].real = i_average;
        n_data[i / factor].imag = q_average;
    }
    n_data[i*factor].real = o_data[i].real;
    n_data[i*factor].imag = o_data[i].imag;
    
    return (arraysize(o_data) / factor);//return size of output data

}
