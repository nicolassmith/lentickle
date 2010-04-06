% [amp, coh, mag] = demod(dat, f, fSamp, nCyc, nAvg, isPlot)
%
% Get the transfer function at one frequency between two time-series.
%

function [amp, coh, mag] = demod(dat, f, fSamp, nCyc, nAvg, isPlot)

  if nargin < 6
    isPlot = 0;
  end

  M_SQRT2 = sqrt(2);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check Parameters
  nPnt = size(dat, 1);
  nSig = size(dat, 2);
  if nSig ~= 2
    error(sprintf('size(dat, 2) is %.1f, but must be 2', nSig));
  end

  nMin = 3;
  if nCyc < nMin
    error(sprintf('nCyc is %.1f, but must be greater than %.1f', nCyc, nMin));
  end
  if nAvg < nMin
    error(sprintf('nAvg is %.1f, but must be greater than %.1f', nAvg, nMin));
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Make Filters
  % make resonant filter
  fRes = filtZPGQ(0, 0, f, nCyc, 1, f);

  % make phase lead/lag filters
  fPI8 = 1.22832821592945;  % f ratio for pi/8 phase shift with Q = 1
  fPhiP = filtZPGQ(0, 0, f * fPI8, 1, 1, f);
  fPhiM = filtZPGQ(0, 0, f / fPI8, 1, 1, f);

  % make post-mixer filters
  fa = f / (nCyc * nAvg);
  fAvg = filtZPGQ([f; 2 * f], [1000; 1000], ...
                  [fa; fa * 2; f / 2], [0; 1; 2], 2, 0);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Demodulate
  % remove initial offset
  if nPnt < 10
    nMean = nPnt;
  else
    nMean = 10;
  end
  dat = dat - repmat(mean(dat(1:nMean, :), 1), [nPnt, 1]);

  % apply pre-filter
  dat = zfilt(fRes, dat, fSamp, f);		% resonant filter

  % make lead and lag products
  dP = zfilt(fPhiP, dat, fSamp, f);		% phase lead (plus)
  dM = zfilt(fPhiM, dat, fSamp, f);		% phase lag (minus)

  dat = zeros(nPnt, 4);
  dat(:, 1) = dP(:, 1) .* dM(:, 1) * M_SQRT2;
  dat(:, 2) = dP(:, 2) .* dM(:, 2) * M_SQRT2;
  dat(:, 3) = dP(:, 1) .* dM(:, 2);
  dat(:, 4) = dP(:, 2) .* dM(:, 1);

  % apply post-filter
  dat = zfilt(fAvg, dat, fSamp, 2 * f);

  % make amplitude and coherence (sqrt(i) to correct for symmetric phase)
  re = (dat(:, 3) + dat(:, 4)) / M_SQRT2;
  im = (dat(:, 3) - dat(:, 4)) / M_SQRT2;

  amp = (re + i * im) ./ dat(:, 1);
  coh = (re.^2 + im.^2) ./ (dat(:, 1) .* dat(:, 2));
  mag = sqrt(dat(:, 1:2));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if ~isPlot
    return
  end

  t = (0:nPnt- 1)' / fSamp;
  subplot(2, 2, 1)
  ns = floor(fSamp / (10 * fa)) + 1;
  a = amp((ns:end), :);
  plot(t(ns:end), [abs(a), real(a), imag(a)])
  grid on
  
  subplot(2, 2, 2)
  plot(t, angle(amp))
  grid on

  subplot(2, 2, 3)
  plot(t, coh)
  grid on

  subplot(2, 2, 4)
  plot(t, mag)
  grid on
