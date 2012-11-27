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

void int_to_float_array(int * int_array, float * float_array, int size)
{
    int i;
    for(i = 0; i < size; ++i)
    {
        float_array[i] = (float) int_array[i];
    }
}

int main()
{
    struct audio_in_t  a_input;
    struct audio_out_t a_output;
    int input_buffer[IN_BUFF_SIZE];
    float in_buffer_f[IN_BUFF_SIZE];

    /* Since we can't use malloc on the board */
    struct complex_t forward_space[IN_BUFF_SIZE];
    struct complex_t backward_space[IN_BUFF_SIZE];

    struct fft_desc_t fft_desc = {
      forward_space,
      IN_BUFF_SIZE
    };

    struct fft_desc_t ifft_desc = {
      backward_space,
      IN_BUFF_SIZE
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

    //'Main' Processing loop
    while(fill_in_buffer(&a_input,
                         input_buffer,
                         arraysize(input_buffer)))
    {
        float mp;

        int_to_float_array(input_buffer,
                           input_buffer_f,
                           arraysize(input_buffer_f));
        // Find fundamental freq

    }

    close_audio_in(&a_input);
    close_audio_out(&a_output);

    return 0;
}
