#!/bin/bash

colour=$1
psfile="power_pressure.ps"
jpgfile=`echo $psfile | sed 's/\.ps/\.jpg/g'`

outdir="./output/${colour}"

mkdir -p $outdir

cp ./{file.txt,$psfile,$jpgfile,fft.inv,surf.grd,fft.pow,signal.h,x_icwt.x,scales.periods,scales_orig.periods,sumpower.fp,synth_sine,freqs.txt} $outdir
cp xmirror.mean $outdir
