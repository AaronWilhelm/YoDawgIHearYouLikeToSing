#include <stdlib.h>
#include <assert.h>
#include "../audio.h"
#include "../global.h"
// Note this is suppost to work with a single channel
// wav file that contains the sequence 1,2,3,...10

int main()
{
    struct audio_in_t input;
    int buffer[10];
    int i;

    input.file_name = "count_wav_in.wav";
    input.info.format = 0;

    init_audio_in(&input);
    
    assert(fill_in_buffer(&input, buffer, arraysize(buffer)));

    for(i = 1; i <= 10; ++i)
    {
        assert(i == buffer[i-1]);
    }

    assert(! fill_in_buffer(&input, buffer, arraysize(buffer)));

    close_audio_in(&input);
    return 0;
}
