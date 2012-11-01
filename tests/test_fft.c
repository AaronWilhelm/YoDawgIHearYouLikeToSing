#include <stdlib.h>
#include <assert.h>
#include "../fft.h"
#include "../global.h"

#define N 16

void zero_seq(struct complex_t * s, int size)
{
    int i;
    for(i = 0; i < size; ++i)
    {
        s[i].real = 0.0;
        s[i].imag = 0.0;
    }
}

int main()
{
    struct fft_desc_t fft_16pt;
    struct complex_t w_s[N];
    struct complex_t seq[N];
    
    fft_16pt.size = N;
    fft_16pt.W    = w_s;
    init_fft_desc(&fft_16pt, N);

    { // Test fft of a sequence of zeros
        int i;

        zero_seq(seq, N);
        fft(&fft_16pt, seq);

        for(i = 0; i < N; ++i)
        {
            assert(seq[i].real < .001);
            assert(seq[i].imag < .001);
        }
    }

    { // Test fft on implulse
        int i;

        zero_seq(seq, N);
        seq[0].real = 1;
        fft(&fft_16pt, seq);

        for(i = 0; i < N; ++i)
        {
            assert(abs(seq[i].real - 1) < .001);
            assert(abs(seq[i].imag) < .001);
        }
    }

    return 0;
}
