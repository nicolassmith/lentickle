%
% amp = modAmp(dat, freq, phase, t0)
%
% dat is Nx2 with t == dat(:,1) and x == dat(:,2)
% freq, phase and t0 describe the reference sin wave:
% sRef = sin( 2 * pi * ((t - t0) * freq - phase / 360) )
%

function amp = modAmp(dat, freq, phase, t0)

  % check data
  if( size(dat, 1) < 10 )
    amp = NaN;
    return
  end

  % compute zero crossings (positive slope and negative slope)
  tp = t0 + phase / (360 * freq);		% a positive ZC
  tn = t0 + (180 + phase) / (360 * freq);	% a negative ZC

  tp0 = ceil((dat(1,1) - tp)*freq)/freq + tp;	% first positive ZC
  tn0 = ceil((dat(1,1) - tn)*freq)/freq + tn;	% first negative ZC

  % compute tStart, tEnd and sense
  if( tp0 < tn0 )
    sense = 1;
    tStart = tp0;
  else
    sense = -1;
    tStart = tn0;
  end

  tEnd = floor((dat(end,1) - tStart) * freq) / freq + tStart;

  % make convolution pairs
  nDat = find(dat(:,1) > tStart & dat(:, 1) <= tEnd);
  tDat = dat(nDat, 1);
  vDat = dat(nDat, 2);
  sDat = sin((tDat - tStart) * 2 * pi * freq) * sense;

  % remove low frequency component from vDat
  vDat = vDat - mean(dat(nDat, 2));
  %wn = freq * (tDat(end) - tDat(1)) / (length(tDat) - 1) * 2;
  %[b, a] = butter(2, wn, 'high');
  %k = freqz(b, a, [0, pi * wn]);
  %vDat = filtfilt(b, a, vDat) / abs(k(2))^2;

  % compute convolution
  amp = 2 * mean(sDat .* vDat);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtering (doesn't work)

  N = length(tDat);
  dt = (tDat(end) - tDat(1)) / (N - 1);
  qual = (tEnd - tStart) * freq / 2;
  mf = filtZPG(freq, filtRes(freq, qual), 1, freq);
  [b, a] = getBAz(mf, 1 / dt);

  fDat = sense * amp * sin((-N * dt:dt:2 * N * dt) * 2 * pi * freq);
  fDat(1:N) = fDat(1:N) + (vDat(1) - fDat(N + 1));
  fDat(2 * N + 1:end) = fDat(2 * N + 1:end) + (vDat(end) - fDat(2 * N));
  fDat(N + 1:2 * N) = vDat;
  plot(dat(:, 1) - tStart, dat(:, 2), -N * dt:dt:2 * N * dt, fDat); pause
  fDat = filtfilt(b, a, fDat);
  fDat = fDat(N + 1:2 * N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old Method

  tEnd = floor((dat(end,1) - t0) * 2 * freq) / (2 * freq) + t0;
  tStart = tEnd - (3 + (90 + phase) / 360) / freq;
  tPeak = tStart + (0.5/freq) * (1:6);
  n = find(dat(:,1) > tStart - 0.2/freq);
  [y, x] = peak(dat(n, 1), dat(n, 2), tPeak, 0.2/freq);

  % fit max's and min's
  pA = polyfit(x(1:2:end), y(1:2:end), 1);
  pB = polyfit(x(2:2:end), y(2:2:end), 1);

  % take diff
  amp = (polyval(pB, tEnd) - polyval(pA, tEnd)) / 2;

%  return

  % plot
  plot(dat(n,1), dat(n,2), 'b', x, y, 'rx', ...
       dat(n,1), polyval(pA, dat(n,1)), 'g', ...
       dat(n,1), polyval(pB, dat(n,1)), 'm');
  grid on
