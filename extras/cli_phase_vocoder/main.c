#include <stdio.h>
#include <stdlib.h>
#include <sndfile.h>
#include <string.h>
#include <global.h>
#include <fft.h>
#include <audio.h>
#include "pvoc.h"

struct fft_desc_t * create_fft_desc(int size, enum FFT_Direction dir)
{
    struct fft_desc_t * ret;
    ret = (struct fft_desc_t *) malloc(sizeof(struct fft_desc_t));
    ret->W = (struct complex_t *) malloc(sizeof(struct complex_t) * 
                                         (size_t) size);
    init_fft_desc(ret, size, dir);
    return ret;
}

void destroy_fft_desc(struct fft_desc_t * r)
{
    free(r->W);
    free(r);
    r = NULL;
}

struct pvoc_ps_t * create_pvoc(int frame_size, int osf, float sf)
{
    struct pvoc_ps_t * ret;
    ret = (struct pvoc_ps_t *)malloc(sizeof(struct pvoc_ps_t));

    // Alloc space for contents
    ret->window = (float *)malloc( sizeof(float) * (size_t) frame_size);
    ret->tmp_wksp = (struct complex_t *)malloc((size_t) frame_size * 
                                               sizeof(struct complex_t));
    ret->last_phase = (float *)malloc((size_t) (frame_size/2+1) *
                                      sizeof(float));
    ret->sum_phase  = (float *)malloc((size_t) (frame_size/2+1) *
                                      sizeof(float));
    ret->fft_desc = create_fft_desc(frame_size,  FFT_FORWARD);
    ret->ifft_desc = create_fft_desc(frame_size, FFT_BACKWARD);

    init_pvoc_ps(ret, frame_size, osf, sf);

    return ret;
}

void destroy_pvoc(struct pvoc_ps_t * r)
{
    destroy_fft_desc(r->fft_desc);
    destroy_fft_desc(r->ifft_desc);
    free(r->window);
    free(r->last_phase);
    free(r->sum_phase);
    free(r->tmp_wksp);
    free(r);
    r = NULL;
}

/**********************************************
 * brief :
 * pre   : pv must be initialized
 *         in must be of size size
 *         out must be of size size
 * note  : This can be optimized to not
 *         have to perform the copying
 *         from in to tmp_in most of the time
 **********************************************/
void pvoc_entire_buffer(struct pvoc_ps_t * pv, 
                        struct complex_t * in,
                        struct complex_t * out,
                        float scale,
                        size_t size)
{
    struct fft_desc_t * fft_desc;
    int i, base_idx, in_latency;
    struct complex_t * tmp_in,
                     * tmp_out,
                     * fft_data;

    fft_desc = create_fft_desc(pv->frame_size, FFT_FORWARD);
    memset(out, 0, size * sizeof(struct complex_t));
    tmp_in = (struct complex_t *)malloc(sizeof(struct complex_t) *
                                        (size_t) pv->frame_size);

    tmp_out = (struct complex_t *)malloc(sizeof(struct complex_t) *
                                         (size_t) pv->frame_size);
    fft_data = (struct complex_t *)malloc(sizeof(struct complex_t) *
                               (size_t) pv->frame_size);

    in_latency = pv->frame_size - pv->step_size;

    for(base_idx = -in_latency;
        base_idx + in_latency < (int)size;
        base_idx += pv->step_size)
    {
        for(i = 0; i < pv->frame_size; ++i)
        {
            if( base_idx + i < 0 || base_idx + i >= size )
            {
                tmp_in[i].real = 0;
            }
            else
            {
                tmp_in[i].real = in[base_idx + i].real;
            }
            tmp_in[i].imag = 0;
        }
        memcpy(fft_data, tmp_in, sizeof(struct complex_t)
               * (size_t)pv->frame_size);
        fft_execute(fft_desc, fft_data);
        
        scale = find_ratio(max_peak(fft_data,pv->frame_size));
        
        pvoc_ps_single_buffer(pv, tmp_in, tmp_out, scale);

        for(i = 0; i < pv->frame_size; ++i)
        {
            int out_idx = base_idx + i + pv->frame_size;

            if( out_idx < size && out_idx > -1 )
            {
                out[out_idx].real += tmp_out[i].real;
            }
        }

    }
    free(tmp_in);
    free(tmp_out);
    free(fft_data);
    destroy_fft_desc(fft_desc);
}

void print_help()
{
    fprintf(stderr, "Proper use:\n   ./pvoc <scaling factor> "
                    "<input audio file>  <output audio file> \n\n");
}


int main(int argc, char *argv[])
{
    struct pvoc_ps_t * pvoc;
    SNDFILE * snd_in, * snd_out;
    SF_INFO info_in, info_out;
    struct complex_t * orig_signal, * new_signal;
    int i;
    float scale;
    char * tst;

    if( argc != 4 )
    {
        print_help();
        exit(4);
    }

    scale = strtof(argv[1], &tst);

    if( scale == 0.0 && tst == argv[1] )
    {
        fprintf(stderr, "Could not convert : "
                "%s into a floating point number\n", argv[1]);
        exit(5);
    }

    if( scale < 0.5 || scale > 1.5 )
    {
        fprintf(stderr, "Invalid scaling factor must be between 0.5 and 1.5\n");
        exit(5);
    }

    snd_in = sf_open(argv[2], SFM_READ, &info_in);

    if( snd_in == NULL )
    {
        fprintf(stderr, "Could not open input audio file\n");
        exit(1);
    }

    if( info_in.channels != 1 )
    {
        fprintf(stderr, "There is not yet support for multichannel audio files\n");
        sf_close(snd_in);
        exit(2);
    }

    info_out.samplerate = info_in.samplerate;
    info_out.channels   = info_in.channels;
    info_out.format     = info_in.format;

    snd_out = sf_open(argv[3], SFM_WRITE, &info_out);
    if( snd_out == NULL )
    {
        fprintf(stderr, "Could not open output audio file\n");
        printf("%d\n", sf_error(snd_out));
        sf_close(snd_in);
        exit(1);
    }


    orig_signal = (struct complex_t *) malloc(sizeof(struct complex_t) *
                                              info_in.frames);
    new_signal = (struct complex_t *) malloc(sizeof(struct complex_t) *
                                             info_in.frames);

    for(i = 0; i < info_in.frames; ++i)
    {
        sf_read_float(snd_in, &(orig_signal[i].real), 1);
        orig_signal[i].imag = 0;
    }
          
    pvoc = create_pvoc(2048, 4, (float) info_in.samplerate);

    pvoc_entire_buffer(pvoc,
                       orig_signal,
                       new_signal,
                       scale,
                       info_in.frames);
    

    for(i = 0; i < info_in.frames; ++i)
    {
        sf_write_float(snd_out, &(new_signal[i].real), 1);
    }

    sf_close(snd_in);
    sf_close(snd_out);
    destroy_pvoc(pvoc);
    free(orig_signal);
    free(new_signal);

    return 0;
}
