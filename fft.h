// Welch, Wright, & Morrow,
// Real-time Digital Signal Processing, 2005

// fft.h
#ifndef FFT_H
#define FFT_H

#include "global.h"

// FFT descriptor type
struct fft_desc_t
{
  struct complex_t * W;
  int  size;
};

// Performs an IN PLACE fft of the complex data
void fft(struct fft_desc_t *, struct complex_t *);
void init_fft_desc(struct fft_desc_t*, int size);

#endif /* FFT_H */
