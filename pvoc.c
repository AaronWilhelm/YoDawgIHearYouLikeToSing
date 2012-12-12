#include "pvoc.h"
#include "audio.h"
#include <string.h>
#include <math.h>

#include <stdio.h>

#define M_PI 3.14159265358979323846

/********************************************************************
 ********************************************************************/
void init_pvoc_ps(struct pvoc_ps_t * pv, 
                  int frame_size,
                  int ov_samp_fact,
                  float sample_rate)
{
    int i;

    // Setup windowing function
    for(i = 0; i < frame_size; ++i)
    {
        pv->window[i] = -.5*cos((float)(2.0*PI*(float)i / 
                                (float)frame_size))
                        + .5;
    }

    pv->over_samp_fact = ov_samp_fact;
    pv->sample_rate    = sample_rate;
    pv->frame_size     = frame_size;
    pv->half_frame     = frame_size / 2;
    pv->step_size      = frame_size / ov_samp_fact;
    pv->expct          = 2.0*M_PI*(double) pv->step_size/(double)frame_size;
    pv->freq_per_bin   = sample_rate / (float) frame_size;

    for(i = 0; i < frame_size/2+1; ++i)
    {
        pv->last_phase[i] = 0.0;
        pv->sum_phase[i]  = 0.0;
    }

    switch( pv->over_samp_fact )
    {
        case 1:
            pv->scale_fact = 6.0;
            break;
        case 3:
            pv->scale_fact = 3.0;
            break;
        default:
            pv->scale_fact = 2.5;
            break;
    }
    
}

/************************************************
 * pre: out_sig and pv->tmp_wksp must already be
 *        allocated
 *      The fft_desc and ifft_desc structs
 *        must be set up the perform 
 *        a fft and ifft, respectively, on array
 *        of size of 'size' the passed to the
 *      The last_phase array should be of size
 *        floor(size/2) + 1 and should initially
 *        be all zeros
 * post : out_sig will contain the output of
 *          the phase vocoding.
 *        pv->tmp_wksp will contains garbarge
 * param : size - size of the fft window
 ************************************************/
void pvoc_ps_single_buffer(struct pvoc_ps_t * pv,
                           float            * in_sig,
                           struct complex_t * out_sig,
                           float pitch_shift)
{
    int i, qpd, index;
    double re, im, tmp, phase, mag;

    // Window data and copy to temp array
    for(i = 0; i < pv->frame_size; ++i)
    {
        pv->tmp_wksp[i].real = in_sig[i] * pv->window[i];
        pv->tmp_wksp[i].imag = 0;
    }

    fft_execute(pv->fft_desc, pv->tmp_wksp);

    pitch_shift = find_ratio(max_peak(pv->tmp_wksp, pv->frame_size));

    /**************************************************
     * At this point the the real portion in pv->tmp_wksp
     * will hold magnitude information while the imag
     * portion will hold the phase information
     *************************************************/
    #define __mag(x)  x.real
    #define __freq(x) x.imag

    /**********************
     ***    Analysis    ***
     **********************/
    for(i = 0; i <= pv->half_frame; ++i)
    {
        re = pv->tmp_wksp[i].real;
        im = pv->tmp_wksp[i].imag;

        __mag(pv->tmp_wksp[i])   = 2.0 * sqrt(re*re + im*im);
        phase = atan2(im, re);

        tmp = phase - pv->last_phase[i];
        pv->last_phase[i] = phase;

        tmp -= (double)i * pv->expct;

        qpd = (tmp/M_PI);

        if( qpd >= 0 )
        {
          qpd += qpd&1;
        }
        else
        {
          qpd -= qpd&1;
        }

        tmp -= (double)(M_PI * (double) qpd);

        tmp = (float)pv->over_samp_fact*tmp/(2.0*PI);

        tmp = pv->freq_per_bin * ((float) i + tmp);

        __freq(pv->tmp_wksp[i]) = tmp;
    }

    /**********************
     ***   Processing   ***
     **********************/
    memset(out_sig, 0, (size_t)pv->frame_size * sizeof(struct complex_t));
    for(i = 0; i <= pv->half_frame; ++i)
    {
        index = (int)((float) i * pitch_shift);
        if( index <= pv->half_frame )
        {
            __mag(out_sig[index]) += __mag(pv->tmp_wksp[i]);
            __freq(out_sig[index]) = __freq(pv->tmp_wksp[i]) * pitch_shift;
        }
    }

    /**********************
     ***   Synthesis    ***
     **********************/
    for(i = 0; i <= pv->half_frame; ++i)
    {
        mag = __mag(out_sig[i]);
        tmp = __freq(out_sig[i]);

        tmp -= (float)i * pv->freq_per_bin;
        tmp /= pv->freq_per_bin;

        tmp = 2*PI*tmp/pv->over_samp_fact;

        tmp += (float)i*pv->expct;

        pv->sum_phase[i] += tmp;
        phase = pv->sum_phase[i];

        out_sig[i].real = mag*cos(phase);
        out_sig[i].imag = mag*sin(phase);
    }

    // Set negative frequencies equal to zero
    for(i = pv->half_frame + 1; i < pv->frame_size; ++i)
    {
        out_sig[i].real = 0;
        out_sig[i].imag = 0;
    }

    fft_execute(pv->ifft_desc, out_sig);

    for(i = 0; i < pv->frame_size; ++i)
    {
        out_sig[i].real *= 2.0*pv->window[i]/
                           (pv->half_frame*pv->over_samp_fact);
        out_sig[i].imag = 0.0; //XXX: Should probably be removed
    }

    #undef __mag
    #undef __freq
}
