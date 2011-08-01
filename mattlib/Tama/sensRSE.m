% Compute the sensing matrix for RSE
% (see also sigRSE, fieldRSE and paramRSE)
%
% [mpr, mpi, mar, mai] = sensRSE(p, gPM, gAM, phiPM, phiAM)
%
%% Example:
% p = paramRSE;
% z = zeros(1, 7);               % start with all positions zero
% z([5, 7]) = 1e-10;          % common end-mirror offset
%
% fPM = 17.25e6;                   % modulation frequency
% gPM = 0.1;                       % modulation depth
% phiPM = zeros(15, 1);            % demod phases... start with zeros
% phiPM(14) = 32;                  % set AP (E14) demod phase
%
% fAM = 103.5e6;                   % modulation frequency
% gAM = 0.1;                       % modulation depth
% phiAM = zeros(15, 1);            % demod phases... start with zeros
% phiAM(2) = -21;                  % set SP (E2) demod phase
%
% [mpr, mpi, mar, mai] = sensRSE(p, gPM, gAM, phiPM, phiAM, z);

function [mpr, mpi, mar, mai] = sensRSE(p, gPM, gAM, phiPM, phiAM, z)

  % check sizes
  if length(z) ~= 7
    error('z should be 1x7 or 7x1')
  end

  if length(phiPM) ~= 15
    error('phiPM should be 1x15 or 15x1')
  end

  if length(phiAM) ~= 15
    error('phiAM should be 1x15 or 15x1')
  end

  % modulation frequencies
  fPM = 17.25e6;
  fAM = 6 * fPM;

  % compute signals
  z = [diag(z); diag(z)] + [eye(7); -eye(7)] * p.lambda / 1e4;
  [pr, pi] = sigRSE(p, 2, fPM, gPM, phiPM, z);
  [ar, ai] = sigRSE(p, 0, fAM, gAM, phiAM, z);

  % make matrices
  mpr = (pr(1:7, :) - pr(8:14, :))';
  mpi = (pi(1:7, :) - pi(8:14, :))';
  mar = (ar(1:7, :) - ar(8:14, :))';
  mai = (ai(1:7, :) - ai(8:14, :))';

  % eliminate small signals
  mpr = rmTiny(mpr);
  mpi = rmTiny(mpi);
  mar = rmTiny(mar);
  mai = rmTiny(mai);
  
%%%%%%%%%%% rmtiny
function m = rmTiny(m)

  mm = 1 ./ (1e-16 + max(abs(m), [], 2));     % max of each row (i.e., sensor)
  mn = diag(mm) * m;                          % sensors normalized to max
  m = m .* (abs(mn) > 1e-4);                  % drop small stuff
