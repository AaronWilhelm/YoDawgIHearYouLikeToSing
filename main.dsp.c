#include <stdint.h>
#include "dsk6713_aic23.h"			            //codec-dsk support file
#include "dsk6713.h"

#include "circ_buff.h"
#include "fft.h"
#include "global.h"
#include "pvoc.h"
#include "audio.h"

Uint32 fs=DSK6713_AIC23_FREQ_8KHZ;	//set sampling rate

extern input_sample();
extern output_sample();
extern comm_intr(); 

/* Since we can't use malloc on the board */
/* ~~~~~~~~~~~~~~~ FFT ~~~~~~~~~~~~~~~~~~ */
struct complex_t forward_space[IN_BUFF_SIZE];
struct complex_t backward_space[IN_BUFF_SIZE];

/* ~~~~~~~~~~~~~~~ PVOC ~~~~~~~~~~~~~~~~~~ */
float pvoc_window[IN_BUFF_SIZE];
struct complex_t pvoc_tmp_wksp[IN_BUFF_SIZE];
float pvoc_last_phase[IN_BUFF_SIZE/2 + 1];
float pvoc_sum_phase[IN_BUFF_SIZE/2 + 1];

/* ~~~~~~~~~~~~~~~ CIRC BUFF ~~~~~~~~~~~~~~~~~~ */
float in_c_buff_space[IN_CIRC_BUFF_SIZE];

float out_c_buff[IN_CIRC_BUFF_SIZE];
float copy_in_buff[IN_BUFF_SIZE];
struct complex_t tmp_out_buff[IN_BUFF_SIZE];



/* ~~~~~~~~~~~~~~~ Global Stuff ~~~~~~~~~~~~~~~~ */
struct fft_desc_t fft_desc = {
    forward_space,
    IN_BUFF_SIZE
};

struct fft_desc_t ifft_desc = {
    backward_space,
    IN_BUFF_SIZE
};

struct pvoc_ps_t pvoc;

struct c_buff_f32 input_c_buff = {
    in_c_buff_space,
    IN_CIRC_BUFF_SIZE,
    0
};

int samp_num = 0;
/* ~~~~~~~~~~~~~~ Interrupt Routines ~~~~~~~~~~~~~~ */
interrupt void c_int11()		    //ISR
{
	int out_idx;
    int latest_idx;
    int output_i;
    int in_samp;
    
    in_samp = input_sample();
     
	push_new_f32(& input_c_buff, ((float) in_samp)/((float)INT16_MAX*100.0));
	//push_new_f32(& input_c_buff, 0.1);
		
	latest_idx = input_c_buff.position;
 	
	if( latest_idx + 1 < input_c_buff.size )
	{
	    out_c_buff[latest_idx+1] = 0.0;
	}
	else
	{
	    out_c_buff[0] = 0.0;
	}
	
	// Write output
	out_idx = latest_idx - pvoc.frame_size;
	
	if( out_idx < 0 )
	    out_idx += input_c_buff.size;
	
	// XXX: This scaling factor should be something a bit more robust
	out_c_buff[out_idx] /= 3.0;
	
	//XXX: need to fix
	output_i = (int)(out_c_buff[out_idx]*(float)INT16_MAX);
	output_sample(output_i);
	
	if( samp_num == pvoc.step_size - 1)
	{
	    float * buff2use;
	    int begin_idx, k, b_idx;
	    
	    samp_num = 0;
	    // Auto-tune time
	    begin_idx = latest_idx - pvoc.frame_size + 1;
	
	    if( begin_idx < 0 )
	        begin_idx += input_c_buff.size;
	
	    if( begin_idx < latest_idx )
	    {
	        buff2use = input_c_buff.data + begin_idx;
	    }
	    else
	    {
	        for(k = 0, b_idx = begin_idx;
	            k < pvoc.frame_size && b_idx < input_c_buff.size;
	            ++k, ++b_idx)
	        {
	            copy_in_buff[k] = input_c_buff.data[b_idx];
	        }
	        for(b_idx = 0; k < pvoc.frame_size; ++k, ++b_idx)
	        {
	            copy_in_buff[k] = input_c_buff.data[b_idx];
	        }
	        buff2use = copy_in_buff;
	    }
	
	    pvoc_ps_single_buffer(&pvoc, buff2use, tmp_out_buff, 1.0);
	
	    for(k = 0, b_idx = begin_idx;
	        k < pvoc.frame_size && b_idx < input_c_buff.size;
	        ++k, ++b_idx)
	    {
	        out_c_buff[b_idx] += tmp_out_buff[k].real;
	    }
	
	    for(b_idx = 0; k < pvoc.frame_size; ++k, ++b_idx)
	    {
	        out_c_buff[b_idx] += tmp_out_buff[k].real;
	    }
	}
	else
	{
	   ++samp_num;
	}

	return;
}


void main()
{
	int i;
	
    //Initialize FFT stuff
    init_fft_desc(&fft_desc,  IN_BUFF_SIZE, FFT_FORWARD);
    init_fft_desc(&ifft_desc, IN_BUFF_SIZE, FFT_BACKWARD);
    
    //Initialize PVOC stuff
    pvoc.window     = pvoc_window;
    pvoc.tmp_wksp   = pvoc_tmp_wksp;
    pvoc.last_phase = pvoc_last_phase;
    pvoc.sum_phase  = pvoc_sum_phase;
    pvoc.fft_desc   = &fft_desc;
    pvoc.ifft_desc  = &ifft_desc;

    init_pvoc_ps(&pvoc, IN_BUFF_SIZE, OV_SAMP_FACT, (float)(SAMPLE_RATE));
	
    // Initialize input and output circular buffers
    for(i = 0; i < input_c_buff.size; ++i)
    {
        input_c_buff.data[i]  = 0.0;
        out_c_buff[i] = 0.0;
    }
	
	input_c_buff.position = 0;
	
	comm_intr();
	
	for(;;) {}
	
	return;
}
