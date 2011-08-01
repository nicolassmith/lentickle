% f = fieldRSE(p, aIn, fMod, z)
%
% Compute fields in RSE
%
%% Example:
%
%% Use Default Input Parameters
% p = paramRSE;
%
%% Make mirror positions.  Column order is:
%%  1 = PR, 2 = SE, 3 = BS, 4 = Ii, 5 = Ei, 6 = Ip, 7 = Ep
% z = zeros(201, 7);               % start with all positions zero
% zsw = (-100:100)'/1e8;           % make a sweep
% z(:, 2) = zsw;                   % sweep signal extraction mirror
%
%% Function Call
% fMod = 17.25e6;                  % modulation frequency
% gMod = 0.1;                      % modulation depth
% ap = bessel(1, gMod) / sqrt(2);  % upper sideband amplitude after MZ
% am = bessel(-1, gMod) / sqrt(2); % lower sideband amplitude after MZ
%
% fc = fieldRSE(p, 1, 0, z);       % compute carrier field
% fp = fieldRSE(p, ap, fMod, z);   % compute upper sideband field
% fm = fieldRSE(p, am, -fMod, z);  % compute lower sideband field
%
%% Plot Upper SB Power in Power Recycling Cavity (E3)
% spp = abs(fp).^2;
% plot(zsw, spp(:,3))

function f = fieldRSE(p, eIn, fMod, z)

  % useful stuff
  N = size(z, 1);
  M = size(z, 2);
  if M == 1
    M = N;
    N = 1;
    z = z';
  end    
  if M ~= 7
    error('z should be Nx7')
  end

  c = 3e8;
  fc = c / p.lambda;
  k = 2 * pi * (fc + fMod) / c;
  ksb = 2 * pi * fMod / c;
  
  % mirror amplitude parameters
  [tp, rp, bp] = mirrorAmp(k, p.Tpr, p.Rpr, z(:, 1) + p.dpr * p.lambda);
  [ts, rs, bs] = mirrorAmp(k, p.Tsr, p.Rsr, z(:, 2) + p.dsr * p.lambda);
  [tb, rb, bb] = mirrorAmp(k, p.Tbs, p.Rbs, z(:, 3) + p.dbs * p.lambda);
  [tv, rv, bv] = mirrorAmp(k, p.Tii, p.Rii, z(:, 4) + p.dii * p.lambda);
  [tx, rx, bx] = mirrorAmp(k, p.Tei, p.Rei, z(:, 5) + p.dei * p.lambda);
  [tw, rw, bw] = mirrorAmp(k, p.Tip, p.Rip, z(:, 6) + p.dip * p.lambda);
  [ty, ry, by] = mirrorAmp(k, p.Tep, p.Rep, z(:, 7) + p.dep * p.lambda);
  
  % propagation phases and losses
  pp = exp(i * ksb * p.Dprbs);
  ps = exp(i * ksb * p.Dsrbs);
  pv = exp(i * ksb * p.Dbsii) * sqrt(1 - p.Lpoi);
  pw = exp(i * ksb * p.Dbsip) * sqrt(1 - p.Lpop);
  px = exp(i * ksb * p.Diiei);
  py = exp(i * ksb * p.Dipep);

  %%%% Build Matrix
  m = zeros(N, 15, 15);
  m(:, 1, 6) = tb * pv * pp;
  m(:, 1, 10) = rb * pw * pp;
  m(:, 2, 1) = tp;
  m(:, 3, 1) = rp;
  m(:, 4, 3) = tb * pp * pv;
  m(:, 4, 15) = bb * ps * pv;
  m(:, 5, 7) = rx * px;
  m(:, 6, 5) = tv;
  m(:, 6, 4) = bv;
  m(:, 7, 4) = tv;
  m(:, 7, 5) = rv;
  m(:, 8, 3) = rb * pp * pw;
  m(:, 8, 15) = tb * ps * pw;
  m(:, 9, 11) = ry * py;
  m(:, 10, 9) = tw;
  m(:, 10, 8) = bw;
  m(:, 11, 8) = tw;
  m(:, 11, 9) = rw;
  m(:, 13, 6) = bb * pv * ps;
  m(:, 13, 10) = tb * pw * ps;
  m(:, 14, 13) = ts;
  m(:, 15, 13) = rs;
  
  % matrix with E0 and without E12
  nuse = [1:11,13:15];
  ninv = 2:15;
  mm = zeros(N, 15, 15);
  mm(:, 3, 1) = bp;
  mm(:, 4, 1) = tp;
  mm(:, ninv, ninv) = m(:, nuse,nuse);
  
  % invert
  eye15 = eye(15);
  vIn = zeros(15, N);
  vIn(1, :) = eIn;
  f0 = zeros(15, N);
  for n = 1:N
    mn = reshape(mm(n, :, :), 15, 15);
    f0(:, n) = (eye15 - mn) \ vIn(:, n);
  end
  f = zeros(N, 15);
  f(:, nuse) = f0(ninv, :)';

%%%%%%%%%%%%%%%%%%%%%%% mirrorAmp
% compute amplitude of transmitted field (t),
% field reflected from front side (r),
% and field reflected from back side (b)
function [t, r, b] = mirrorAmp(k, T, R, z)

  t = sqrt(T);
  b = sqrt(R) * exp(2i * k * z);
  r = -conj(b);
  