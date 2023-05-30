# Wavelets (`pycwt` wrapper)
[![DOI](https://zenodo.org/badge/432215846.svg)](https://zenodo.org/badge/latestdoi/432215846)

Go-to repository for wavelet analysis code (basically a wrapper for [`pycwt`](https://github.com/regeirk/pycwt)).

Requires `pycwt` and `Python 3.8` or higher.

You can import `quick_wavelet` and then run either `run_full_wavelet_analysis` or `run_double_wavelet_analysis` (see `wrapper.py`), after setting appropriate inputs.
Run `./plot_quick_double_results.sh` in Bash shell to recreate example below. To successfully reproduce the plots you will need Generic Mapping Tools v6 or higher, and Imagemagick (for conversion from `.ps` to `.jpg`).

Scripts adapted from this repository were used to carry out analysis in [O'Malley et al. (2023; GEB)](https://onlinelibrary.wiley.com/doi/full/10.1111/geb.13702).

Run `make_sine.gmt` in the `SYNTHETICS` directory to benchmark code: as-is, it should reproduce the plot in the relevant output directory from scratch, for the white noise signal. So, if you don't want to overwrite the existing file, to make sure you have successfully benchmarked the code, comment out the `move_output.sh` line in `make_sine.gmt` before running. Change `$colour` in `make_sine.gmt` to re-run for either blue or red noise signals.

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
