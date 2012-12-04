#ifdef FOR_PC
  #include <stdio.h>
#elif FOR_DSP

#else
  #error "Not a supported platform"
#endif

#include <stdint.h>
#include "fft.h"
#include "audio.h"
#include "global.h"
#include "pvoc.h"
#include "circ_buff.h"


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
float out_c_buff_space[IN_CIRC_BUFF_SIZE];


int push_audio_in_samp(struct audio_in_t * a_input, 
                       struct c_buff_f32 * input_c_buff)
{
    int ret, sample_i;
    ret = fill_in_buffer(a_input, &sample_i, 1);
    push_new_f32(input_c_buff, (float) sample_i);
    return ret;
}

int main()
{
    int i, samp_num;
    struct audio_in_t  a_input;
    struct audio_out_t a_output;

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
    
    struct c_buff_f32 output_c_buff = {
        out_c_buff_space,
        IN_CIRC_BUFF_SIZE,
        0
    };


    //Initialize Sound
#ifdef FOR_PC
    a_input.file_name = "test_in.wav";
    a_output.file_name = "test_out.wav";
#endif

    init_audio_in(&a_input);
    init_audio_out(&a_output);

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

    init_pvoc_ps(&pvoc, IN_BUFF_SIZE, OV_SAMP_FACT, SAMPLE_RATE);

    // Initialize input and output circular buffers
    for(i = 0; i < input_c_buff.size; ++i)
    {
        input_c_buff.data[i]  = 0.0;
        output_c_buff.data[i] = 0.0;
    }

    samp_num = 0;
    //'Main' Processing loop
    while( push_audio_in_samp(&a_input, &input_c_buff) )
    {
        // XXX: Write audio out

        if( samp_num == pvoc.step_size - 1)
        {
            // XXX: Run PVOC
        }

        samp_num = (samp_num + 1) % pvoc.step_size;
    }

    close_audio_in(&a_input);
    close_audio_out(&a_output);

    return 0;
}
