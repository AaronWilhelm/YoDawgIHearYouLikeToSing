#ifndef GLOBAL_H
#define GLOBAL_H

#define arraysize(a) (sizeof(a)/sizeof(a[0]))

#define IN_BUFF_SIZE 128
#define PI 3.14159265358979323846
#define SAMPLE_RATE 44100
#define NOTE_ARRAY_LENGTH 33

struct complex_t
{
    float real;
    float imag;
};


static float notes [NOTE_ARRAY_LENGTH] = {65.41, 73.42, 82.41, 87.31, 98, 110, 123.47, 130.81, 146.83, 164.81,
        174.61, 196, 220, 246.94, 261.63, 293.66, 329.63, 349.23, 392, 440, 493.88,
        523.25, 587.33, 659.26, 698.46, 783.99, 880, 988, 1047, 1175, 1319, 1397, 1568};



#endif /* GLOBAL_H */
