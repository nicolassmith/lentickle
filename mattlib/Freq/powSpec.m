% p = powSpec(x, fs, fMin)
%
% x    - time series to analyze
% fs   - sample frequency
% fMin - lowest frequency in the FFT

function [p, f] = powSpec(x, fs, fMin)

  % compute FFT size
  n = ceil(1 - log2(fMin / fs));
  if( n < 2 )
    n = 2;
  elseif( 2^n > length(x))
    n = floor(log2(length(x)));
  end

  % compute power spectrum
  [pp, fp] = spectrum(x, 2^n, 2^(n - 1), [], fs);
  nfp = find(fp > 0);
  p = pp(nfp, 1) / fs;
  f = fp(nfp);
  
  % loglog resample
  %nfp = find(fp > 0);
  %nf = find(f > min(fp(nfp)) & f < max(fp(nfp)));
  %p = repmat(NaN, size(f));
  %p(nf) = exp(spline(log(fp(nfp)), log(pp(nfp)), log(f(nf))));
