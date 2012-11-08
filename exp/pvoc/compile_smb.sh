#!/bin/bash

CFLAGS="-I ../../ -lm -lsndfile"
CFILES="smbPitchShift.c ../../fft.c"

echo gcc $CFLAGS $CFILES -o smb
gcc $CFLAGS $CFILES -o smb
