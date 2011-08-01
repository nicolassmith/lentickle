% [z, z0] = scanFit(lambda, dat, frac)
%
% dat is a the data from a beam scanner
%  the first column is position, the rest are beam diameter measurements
%  at various heights on the beam
%
% frac is a vector of height values for each measurement in dat
% 
%% Example:
% lambda = 1064e-6;                   % in millimeters
% frac = [13.5, 36.8,50,60.7]/100;
% dat = load('scan00.txt');
% dat(:,1) = dat(:,1) * 10;           % cm to mm for position data
% dat(:,2:end) = dat(:,2:end) / 1000; % um to mm for beam data
% [zx, z0x] = scanFit(lambda, dat(:,[1,2:2:end]),frac)
% [zy, z0y] = scanFit(lambda, dat(:,[1,3:2:end]),frac)

function [z, z0] = scanFit(lambda, dat, frac)

  % convert all data to beam width
  r = 2 * sqrt(-log(frac) / 2);
  dw = dat(:, 2:end) * diag(1./r);
  x = dat(:,1);
  N = size(dat, 1);
  
  % make initial guess
  NN = 10 * N;
  xx = (max(x) - min(x)) * (0:1:(NN - 1)) / NN + min(x);
  yy = spline(x, dw(:, end), xx);
  [w, n] = min(yy);
  [z, z0] = beamQZ(Inf, w / 2, lambda);
  z = xx(n);
  
  % fit
  zz = [z, z0]
  zz = fminsearch('scanFit_erf', zz, [], x, dw, lambda);

  % build output
  z = zz(1);
  z0 = zz(2);
  
  if nargout < 2
    z = z + i * z0;
  end

  % plot output
  [R, w] = beamRW(z0, z - xx, lambda);
  plot(x, dw, 'x', xx, w)
  