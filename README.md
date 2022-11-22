# Wavelets (`pycwt` wrapper)
[![DOI](https://zenodo.org/badge/432215846.svg)](https://zenodo.org/badge/latestdoi/432215846)

Go-to repository for wavelet analysis code (basically a wrapper for [`pycwt`](https://github.com/regeirk/pycwt)).

Requires `pycwt` and `Python 3.8` or higher.

You can import `quick_wavelet` and then run either `run_full_wavelet_analysis` or `run_double_wavelet_analysis` (see `wrapper.py`).
Run `./plot_quick_double_results.sh` in Bash shell to recreate example below.

Scripts adapted from this repository were used to carry out analysis in [O'Malley et al. (2022; sub jud. GEB)](https://www.biorxiv.org/content/10.1101/2022.01.21.477239v3).

CC BY 4.0 license (see `LICENSE.txt`).

![](quick_double_results.jpg)
(a) Signal 1 (amphibian species richness).\
(b) Continuous wavelet transform of (a); rectified power.\
(c) Black line = distance-averaged rectified power from (b). Grey line = power from Fourier transform of (a).\
(d) Signal 2 (carnivoran species richness).\
(e) Continuous wavelet transform of (b); rectified power.\
(f) Black line = distance-averaged rectified power from (e). Grey line = power from Fourier transform of (d).\
(g) Cross wavelet power for signals (a) and (d). Orange arrows = phase. Right-hand facing arrows (bearing = 090) = in-phase. Left-hand facing arrows (bearing = 270) = out of phase.\
(h) Distance-averaged cross wavelet power from (g).\
(i) Wavelet coherence between signals (a) and (d).\
(j) Distance-averaged wavelet coherence from (i).\
(k) Phase difference for cross wavelet transform as in (g).
