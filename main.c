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

int main()
{
    struct audio_in_t  a_input;
    struct audio_out_t a_output;
    int input_buffer[IN_BUFF_SIZE];
  
    //Initialize Sound
#ifdef FOR_PC
    a_input.file_name = "test_in.wav";
    a_output.file_name = "test_out.wav";
#endif

    init_audio_in(&a_input);
    init_audio_out(&a_output);

    //Initialize FFT stuff

    //'Main' Processing loop
    while(fill_in_buffer(&a_input,
                         input_buffer,
                         arraysize(input_buffer)))
    {

    }

    close_audio_in(&a_input);
    close_audio_out(&a_output);

    return 0;
}
