% [h, f] = tfME(x, y, fs, dt)
% or
% [h, coh, f] = tfME(x, y, fs, dt)
%
% In the second case, the coherence is also returned (see cohME).
%
% x is the input signal
% y is the output signal
% fs is the data sample frequency
% dt is the approximate FFT length
%
% This function is based on TFESTIMATE.  It uses a HANN window
% and default FFT overlap.

function [h, varargout] = tfME(x, y, fs, dt)

  % compute transfer function
  Nfft = 2^ceil(log2(dt * fs));
  w = hann(Nfft);
  [h, f] = tfestimate(x, y, w, [], [], fs);

  % varargout
  switch nargout
   case 1
    % nothing
   case 2
    varargout = {f};
   case 3
    coh = mscohere(x, y, w, [], [], fs);
    varargout = {coh, f};
   otherwise
    error('Too many output arguments');
  end
