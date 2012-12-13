// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2005

// This code calculates the fft of an N point complex data sequence, x[N].

//   The fft of real input values can be calculated by omitting the 
//   x[].imag declarations. The fft results (the N complex numbers) are 
//   returned in x[N]. This algorithm is based on the discussion in,

//   "C Algorithms for Real-Time DSP", by Paul M. Embree
//   Prentice-Hall PTR, copyright 1995.

#include <math.h>
#include "fft.h"

	
void fft_c(int n, struct complex_t *x, struct complex_t *W)
{
    struct complex_t u, temp, tm;
    struct complex_t *Wptr;

    int i, j, k, len, Windex; 

	/* start fft */
    Windex = 1;
    for(len = n/2 ; len > 0 ; len /= 2) {
        Wptr = W;
        for (j = 0 ; j < len ; j++) {
            u = *Wptr;
            for (i = j ; i < n ; i = i + 2*len) {
                temp.real = x[i].real + x[i+len].real;
                temp.imag = x[i].imag + x[i+len].imag;
                tm.real = x[i].real - x[i+len].real;
                tm.imag = x[i].imag - x[i+len].imag;
                x[i+len].real = tm.real*u.real - tm.imag*u.imag;
                x[i+len].imag = tm.real*u.imag + tm.imag*u.real;
                x[i] = temp;
            }
            Wptr = Wptr + Windex;
        }
        Windex = 2*Windex;
    }

	/* rearrange data by bit reversing */
	j = 0;
	for (i = 1; i < (n-1); i++) {
		k = n/2;
		while(k <= j) {
			j -= k;
			k /= 2;
		}
		j += k;
		if (i < j) {
			temp = x[j];
			x[j] = x[i];
			x[i] = temp;
		}
	}
}


void fft(struct fft_desc_t * desc, struct complex_t * data)
{
  fft_c(desc->size, data, desc->W);
}

void init_fft_desc(struct fft_desc_t * desc, int n, enum FFT_Direction dir)
{
    int i;
	float a = 2.0*PI/n;
    float coeff;
    
    desc->size = n;

    switch(dir)
    {
        case FFT_FORWARD:
            coeff = -1.0;
            break;
        case FFT_BACKWARD:
            coeff = 1.0;
            break;
        default:
            //TODO: Throw error
            break;
    }

    for(i = 0 ; i < n ; i++)
    {
      desc->W[i].real = (float) cos(coeff*i*a);
      desc->W[i].imag = (float) sin(coeff*i*a);
    }

}

void fft_execute(struct fft_desc_t * desc, struct complex_t * signal)
{
    fft_c(desc->size, signal, desc->W);
}
