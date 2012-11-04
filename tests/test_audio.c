#include <stdlib.h>
#include <assert.h>
#include "../audio.h"
#include "../global.h"
// Note this is suppost to work with a single channel
// wav file that contains the sequence 1,2,3,...10

const char * wav_file = "test_file.wav";
const int correct_in_seq[] = {0,          //  0/10
                              214761472,  //  1/10
                              429457408,  //  2/10
                              644218880,  //  3/10
                              858980352,  //  4/10
                              1073741824, //  5/10
                              1288437760, //  6/10
                              1503199232, //  7/10
                              1717960704, //  8/10
                              1932656640}; // 9/10

int main()
{
  { // Test writing
    int i;
    struct audio_out_t output;
    float buffer[10];

    output.file_name = (char *) wav_file;
    init_audio_out(&output);

    for(i = 0; i < 10; ++i)
    {
        buffer[i] = ((float) i)/10.0;
    }

    write_audio_buffer_float(&output, buffer, arraysize(buffer));

    close_audio_out(&output);
  }

  { // Test reading
    struct audio_in_t input;
    int buffer[10];
    int i;

    input.file_name = (char *) wav_file;

    init_audio_in(&input);
    
    assert(fill_in_buffer(&input, buffer, arraysize(buffer)));

    for(i = 0; i < 10; ++i)
    {
        assert(correct_in_seq[i] == buffer[i]);
    }

    assert(! fill_in_buffer(&input, buffer, arraysize(buffer)));

    close_audio_in(&input);
  }

  return 0;
}
