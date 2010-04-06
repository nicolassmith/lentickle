% [amp, coh] = demod2(dat, f, fSamp, tAvg, nCoh)
%
% Get the transfer function at one frequency between two time-series.
%

function [amp, coh] = demod2(dat, f, fSamp, nCyc, nAvg)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check Parameters
  nSig = size(dat, 2);
  if nSig == 0
    amp = [];
    coh = [];
  end

  nMin = 2;
  if nCyc < nMin
    error(sprintf('nCyc is %.1f, but must be greater than %.1f', nCyc, nMin));
  end
  if nAvg < nMin
    error(sprintf('nAvg is %.1f, but must be greater than %.1f', nAvg, nMin));
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Make Filters
  % make phase lead/lag filters
  fPI8 = 1.22832821592945;  % f ratio for pi/8 phase shift with Q = 1
  fPhiP = filtZPG(0, filtRes(f * fPI8, 1), 1, f);
  fPhiM = filtZPG(0, filtRes(f / fPI8, 1), 1, f);
  fPhiL = filtZPG(0, filtRes(f, 1), 1, f);

  % make resonant filter
  nAll = nCyc * nAvg;
  fRes = filtZPG(0, filtRes(f, nCyc), 1, f);

  % make post-mixer filters
  fAmp = filtZPG(filtRes(2 * f, 100), ...
                 filtRes(2 * f / nCyc, 0.8), 2, 0);

  fAvg = filtZPG(filtRes(2 * f, 100), ...
                 filtRes(2 * f / nAll, 0.8), 2, 0);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Demodulate
  % remove initial offset
  if size(dat, 1) < 10
    nPnt = size(dat, 1);
  else
    nPnt = 10;
  end
  dat = dat - repmat(mean(dat(1:nPnt, :), 1), [size(dat, 1), 1]);
  
  % apply pre-filters
  dat = zfilt(fRes, dat, fSamp, f);
  dP = zfilt(fPhiP, dat, fSamp, f);
  dM = zfilt(fPhiM, dat, fSamp, f);
  dL = zfilt(fPhiL, dat(:, 1), fSamp, f);

  % make lead and lag products
  dlP = repmat(dP(:, 1), [1, nSig - 1]);
  dlM = repmat(dM(:, 1), [1, nSig - 1]);

  dpP = dP(:, 2:end) .* dlM;
  dpM = dM(:, 2:end) .* dlP;
  dpL = dL .* dL;

  % apply post-filters
  daP = zfilt(fAmp, dpP, fSamp, 2 * f);
  daM = zfilt(fAmp, dpM, fSamp, 2 * f);
  daL = zfilt(fAmp, dpL, fSamp, 2 * f);


%  dr = repmat(abs(daM(:, 1)), [1, nSig]);
%  di = repmat(abs(daP(:, 1)), [1, nSig]);
%  amp = daP ./ dr + i * daM ./ di;
%  amp(:, 1) = sqrt(abs(daP(:,1)));
%
%  dr = repmat(abs(dcM(:, 1)), [1, nSig]);
%  di = repmat(abs(dcP(:, 1)), [1, nSig]);
%  ac = amp .* conj(dcP ./ dr + i * dcM ./ di);
%  coh = (real(ac) ./ abs(ac)).^4;
%  coh = zfilt(fCo2, coh, fSamp);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %return
  %pause
  for n = 1:nSig-1
    subplot(nSig, 2, 2 * n - 1)
    plot([dL, dP(:, n), dM(:, n), dpP(:, n), dpM(:, n)]);
    grid on
    subplot(nSig, 2, 2 * n)
    plot([daL, daP(:, n), daM(:, n), dcP(:, n), dcM(:, n)]);
    grid on
  end  

  return
  subplot(2, 1, 1)
  plot([real(amp(:,2:end)), imag(amp(:,2:end)), abs(amp(:,2:end))])
  subplot(2, 1, 2)
  plot(coh(:,2:end))

