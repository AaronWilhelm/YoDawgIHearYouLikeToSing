#ifndef PVOC_H
#define PVOC_H

#include "global.h"
#include "fft.h"

// Phase vocoder phase shifter type
struct pvoc_ps_t
{
    /* Vars not up updated every iteration */
    float * window;
    int     frame_size;
    float   sample_rate;
    int     over_samp_fact;
    struct fft_desc_t * fft_desc;
    struct fft_desc_t * ifft_desc;

    // Extras for convenience
    int   step_size;
    int   half_frame;
    //float expct;
    double expct;
    float freq_per_bin;

    /* Vars up modified every iteration */
    float * last_phase;
    float * sum_phase;

    struct complex_t * tmp_wksp;
};

void init_pvoc_ps(struct pvoc_ps_t * pv, 
                  int frame_size,
                  int ov_samp_fact,
                  float sample_rate);

void pvoc_ps_single_buffer(struct pvoc_ps_t * pv,
                           float            * in,
                           struct complex_t * out, 
                           float pitch_shift);

#endif /* PVOC_H */
