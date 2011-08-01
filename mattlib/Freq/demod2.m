% [amp, coh] = demod2(dat, f, fSamp, nCyc, nAvg)
%
% Get the transfer function at one frequency between two time-series.
%

function [amp, coh] = demod2(dat, f, fSamp, nCyc, nAvg)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check Parameters
  nPnt = size(dat, 1);
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
  fAmp = filtZPG(filtRes(2 * f, 1000), filtRes(2 * f, 10), 2, 0);
  fAvg = filtZPG([], f / nAll, 1, 0);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Demodulate
  % remove initial offset
  if nPnt < 10
    nMean = nPnt;
  else
    nMean = 10;
  end
  dat = dat - repmat(mean(dat(1:nMean, :), 1), [nPnt, 1]);
  
  % apply pre-filters
  dat = zfilt(fRes, dat, fSamp, f);
  dP = zfilt(fPhiP, dat, fSamp, f);		% phase advanced (plus)
  dM = zfilt(fPhiM, dat, fSamp, f);		% phase retarded (minus)
  dL = zfilt(fPhiL, dat(:, 1), fSamp, f);	% local oscillator (LO)

  % make lead and lag products
  dlP = repmat(dP(:, 1), [1, nSig]);
  dlM = repmat(dM(:, 1), [1, nSig]);

  dsin = sin(2 * pi * (f / fSamp) * (1:size(dat,1))');
  dsin = zfilt(fRes, dsin, fSamp, f);
  dlP(:, 1) = zfilt(fPhiP, dsin, fSamp, f);	% use reference sinusoid
  dlM(:, 1) = zfilt(fPhiM, dsin, fSamp, f);	% for LO signal
  
  dpP = dP .* dlM;
  dpM = dM .* dlP;
  dpL = dL .* dL;

  % filter out 2nd harmonic component
  daP = zfilt(fAmp, dpP, fSamp, 2 * f);
  daM = zfilt(fAmp, dpM, fSamp, 2 * f);
  daL = zfilt(fAmp, dpL, fSamp, 2 * f);

  % make coherence denominator
  daMag = sqrt(daP.^2 + daM.^2);
  dsMag = zfilt(fAvg, daMag, fSamp);
  
  % apply averaging filter
  dsP = zfilt(fAvg, daP, fSamp);
  dsM = zfilt(fAvg, daM, fSamp);
  dsL = zfilt(fAvg, daL, fSamp);
  
  % make amplitude and coherence
  amp = (dsP + i * dsM) / sqrt(i);	% correct for symmetric phase
  coh = (dsP.^2 + dsM.^2) ./ dsMag.^2;

  % normalize other signals to LO magnitude
  dn = repmat(dsL, [1, nSig - 1]);
  amp(:, 2:nSig) = amp(:, 2:nSig) ./ dn;

  % normalize LO to remove filter response
  dn = zfilt(fPhiL, dsin, fSamp, f);
  dn = zfilt(fAmp, dn .* dn, fSamp, 2 * f);
  dn = zfilt(fAvg, dn, fSamp);
  amp(:, 1) = amp(:, 1) ./ dn;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  return

  subplot(2, 1, 1)
  plot([real(amp), imag(amp), abs(amp)])
  subplot(2, 1, 2)
  plot(coh)

  return
  %pause

  for n = 1:nSig
    subplot(nSig, 2, 2 * n - 1)
    plot([dL, dP(:, n), dM(:, n), dpP(:, n), dpM(:, n)]);
    grid on
    legend('dL', 'dP', 'dM', 'dpP', 'dpM');
    subplot(nSig, 2, 2 * n)
    plot([dsL, dsP(:, n), dsM(:, n), daP(:, n), daM(:, n)]);
    grid on
    legend('dsL', 'dsP', 'dsM', 'daP', 'daM');
  end  
