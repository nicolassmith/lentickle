%
% [bz, az] = getBAz(mf, fs)
%
% get Z-domain transfer-function numerator and denominator
%

function [bz, az] = getBAz(mf, fs, varargin)

  [zz, pz, kz] = getZPKz(mf, fs, varargin{:});
  [bz, az] = zp2tf(zz, pz, kz);
