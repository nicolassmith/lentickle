% [a, f] = specME(x, y, fs, dt)
%
% x is the input signal
% fs is the data sample frequency
% dt is the approximate FFT length
%
% The return values are the amplitude spectrum and frequency vector.
% This function is based on PWELCH.  It uses a HANN window
% and default FFT overlap.

function [a, f] = specME(x, fs, dt)

  Nfft = 2^ceil(log2(dt * fs));
  w = hann(Nfft);
  [a, f] = pwelch(x, w, [], [], fs);
  a = sqrt(a);
