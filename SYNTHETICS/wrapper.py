#!/usr/bin/env python3.8

#########################################################################################
# wrapper script to run wavelet transform code. it calls quick_wavelet.py, which 
# in turn calls processing_wav.py. it assumes that pycwt is installed on python 3, 
# e.g. via > pip install pycwt. 
# see https://github.com/Malley1/Wavelets-pycwt-wrapper for more details. 
#
# there are two examples below, the first (> quick_wavelet.run_double_wavelet_analysis) 
# performs transformations of two time series and compares them, formally, the cross 
# wavelet transform and coherence are calculated. the second (quick_wavelet.run_full_wavelet_analysis)
# transforms a single time series. you can visualise output of the second example using 
# the gmt script provided (> plot_pressure_basic.gmt).
#
# conor o'malley & gareth roberts
# gareth.roberts@imperial.ac.uk 
#########################################################################################


import sys
import quick_wavelet

infile1 = sys.argv[1]
#infile2 = sys.argv[2]

#quick_wavelet.run_double_wavelet_analysis(infile1, infile2, dt=1.29, mirror=False, cut1=None, cut2=None, write_output=True, wf='dog', dj=0.1, om0=6, normmean=False)

quick_wavelet.run_full_wavelet_analysis(infile1, dt=1.29, mirror=False, cut1=None, cut2=None, write_output=True, wf='morlet', dj=0.1, om0=6, normmean=False, mirrormethod=2)
