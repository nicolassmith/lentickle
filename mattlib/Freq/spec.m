% p = powSpec(x, fMin, fs)
%
% x    - time series to analyze
% fMin - frequencies at which to return values
% fs   - sample frequency

function [p, f, n] = spec(x, fMin, fs)

  % compute FFT size
  n = ceil(1 - log2(fMin / fs));
  if( n < 2 )
    n = 2;
  elseif( 2^n > length(x))
    n = floor(log2(length(x)));
  end

  % compute power spectrum
  [p, f] = spectrum(x, 2^n, 2^(n - 1), [], fs);
  p = p(:, 1) / fs;
