#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <time.h>
#include <string.h>
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

float rand_norm_float()
{
    static const int max = 1000;
    int top = rand() % max;

    return ((float) top)/((float) max);
}

void gen_rand_seq(struct complex_t * seq, int size)
{
    int i;
    for(i = 0; i < size; ++i)
    {
        seq[i].real = rand_norm_float();
        seq[i].imag = rand_norm_float();
    }
}

int main()
{
  srand(time(NULL));

  { // Test forward transform (FFT)
    struct fft_desc_t fft_Npt;
    struct complex_t w_s[N];
    struct complex_t seq[N];
    int i;
    
    fft_Npt.W    = w_s; // Since Malloc'ing isn't an option
    init_fft_desc(&fft_Npt, N, FFT_FORWARD);

    // Test with a sequence of zeros
    zero_seq(seq, arraysize(seq));
    fft_execute(&fft_Npt, seq);

    for(i = 0; i < N; ++i)
    {
        assert(seq[i].real < .001);
        assert(seq[i].imag < .001);
    }

    // Test with a unit impulse
    zero_seq(seq, arraysize(seq));
    seq[0].real = 1;    
    fft_execute(&fft_Npt, seq);

    for(i = 0; i < N; ++i)
    {
        assert(abs(seq[i].real - 1) < .001);
        assert(seq[i].imag < .001);
    }
  }

  { // Test with backward transform (IFFT)
    struct fft_desc_t ifft_Npt;
    struct complex_t w_s[N];
    struct complex_t seq[N];
    int i;
    
    ifft_Npt.W    = w_s; // Since Malloc'ing isn't an option
    init_fft_desc(&ifft_Npt, N, FFT_BACKWARD);

    // Test FFT{x} = real constant
    for(i = 0; i < N; ++i)
    {
        seq[i].real = 1.0;
        seq[i].imag = 0.0;
    }

    fft_execute(&ifft_Npt, seq);

    assert(abs(seq[0].real - N) < .001);
    assert(abs(seq[0].imag) < .001);

    for(i = 1; i < N; ++i)
    {
        assert(abs(seq[i].real) < .001);
        assert(abs(seq[i].imag) < .001);
    }

    // Test FFT{x} = impulse
    zero_seq(seq, N);
    seq[0].real = 1;

    fft_execute(&ifft_Npt, seq);

    for(i = 0; i < N; ++i)
    {
        assert(abs(seq[i].real - 1) < .001);
        assert(abs(seq[i].imag) < .001);
    }

  }

  { // Test that the IFFT of an FFT'ed sequence
    // is the original sequence
    int i, trial;
    int num_trials = 10;
    struct fft_desc_t fft_Npt, 
                      ifft_Npt;
    struct complex_t w_f[N];
    struct complex_t w_b[N];
    struct complex_t seq[N],
                     orig_seq[N];
    
    fft_Npt.W    = w_f; // Since Malloc'ing isn't an option
    init_fft_desc(&fft_Npt, N, FFT_FORWARD);

    ifft_Npt.W    = w_b; // Since Malloc'ing isn't an option
    init_fft_desc(&ifft_Npt, N, FFT_BACKWARD);


    for(trial = 0; trial < num_trials; ++trial)
    {
        gen_rand_seq(orig_seq, arraysize(orig_seq));

        memcpy(seq, orig_seq, (size_t) sizeof(seq));

        fft_execute(&fft_Npt,  seq);
        fft_execute(&ifft_Npt, seq);

        for(i = 0; i < N; ++i)
        {
            assert((16.0 * orig_seq[i].real - seq[i].real) < .001);
            assert((16.0 * orig_seq[i].imag - seq[i].imag) < .001);
        }
    }
  }
  return 0;
}
