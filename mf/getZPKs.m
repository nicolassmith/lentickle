%
% [zs, ps, ks] = getZPKs(mf)
%
% get S-domain zeros and poles for mf
%

function [zs, ps, ks] = getZPKs(mf)

  zs = -2 * pi * mf.z;
  ps = -2 * pi * mf.p;
  ks = (2 * pi)^(length(mf.p) - length(mf.z)) * mf.k;
