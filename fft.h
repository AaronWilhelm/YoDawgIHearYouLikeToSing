// Welch, Wright, & Morrow,
// Real-time Digital Signal Processing, 2005

// fft.h
#ifndef FFT_H
#define FFT_H

#include "global.h"

/***************************************************************
 * NOTES: 1) Currently, this uses the radix-2
 *           FFT algorithm which requires
 *           that the input size be a power of 2.
 *        2) The way that this normalizes the
 *           fft calculation is a follows;
 *           assume N is the size of the fft,
 *           x is the time series sequence,
 *           X is the TRUE frequency domain representation of x,
 *           fft(.) is the fft function in fft.{h,c}
 *           and ifft(.) is the ifft function in fft.{h,c}
 *           
 *           X = fft(x)
 *           N*x = ifft(X)
 *        3) Currently, the only way to perform the fft or ifft
 *           is to perform it as an in place operation
 *           (destroys the input array to make way for the output)
 ***************************************************************/

enum FFT_Direction
{
    FFT_FORWARD,  // FFT
    FFT_BACKWARD  // IFFT
};

// FFT descriptor type
struct fft_desc_t
{
  struct complex_t * W;
  int  size;
};


/************************************************
 *              FFT Routines
 ************************************************/
// Initialize FFT "descriptor"
void init_fft_desc(struct fft_desc_t *,
                   int size,
                   enum FFT_Direction);

// Performs an IN PLACE fft of the complex data
void fft_execute(struct fft_desc_t *, struct complex_t *);

#endif /* FFT_H */
