% [coh, f] = cohME(x, y, fs, dt)
%
% x is the input signal
% y is the output signal
% fs is the data sample frequency
% dt is the approximate FFT length
%
% This function is based on MSCOHERE.  It uses a HANN window
% and default FFT overlap.

function [coh, f] = cohME(x, y, fs, dt)

  % compute transfer function
  Nfft = 2^ceil(log2(dt * fs));
  w = hann(Nfft);
  [coh, f] = mscohere(x, y, w, [], [], fs);
