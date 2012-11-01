#ifdef FOR_PC
  #include <stdio.h>
#elsif FOR_DSP

#else
  #error "Not a supported platform"
#endif

#include <stdint.h>
#include "fft.h"
#include "audio.h"
#include "global.h"

int main()
{
    struct audio_in_t a_input;
    int input_buffer[IN_BUFF_SIZE];
  
    //Initialize Sound
#ifdef FOR_PC
    audio_in_t.file_name = "test_in.wav";
#endif

    init_audio_in(&a_input);

    //Initialize FFT stuff

    //'Main' Processing loop
    while(fill_in_buffer(&a_input,
                         input_buffer,
                         arraysize(input_buffer)))
    {
    
    }

    return 0;
}
