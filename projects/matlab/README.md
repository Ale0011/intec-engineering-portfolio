# Audio signal processing in MATLAB

**Based on INTEC coursework, 2017.** The archived draft used an audio recording to explore sampling, the FFT, Butterworth filtering, and PCM quantization. This reconstruction uses generated tones so it runs without the original audio, local paths, or a signal-processing toolbox.

Run `audio_pcm_demo` from this directory in MATLAB or GNU Octave. The script plots the input, filtered and quantized signals, their spectra, and the quantization error. For a headless run, set the environment variable `PORTFOLIO_HEADLESS` to `1`.

- Sample rate: 8 kHz.
- Input: 440 Hz and 2.6 kHz tones.
- Filter: second-order Butterworth low-pass at 1.5 kHz.
- Quantizer: 8-bit uniform PCM with 256 levels.

The demo checks preservation of the lower tone, attenuation of the higher tone, and the expected quantization error bound. It is a new, self-contained reconstruction of the coursework concepts; it does not include the unfinished line-coding stage of the historical draft.
