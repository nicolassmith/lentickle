%
% [z, p, k] = getZPK(mf)
%
% get zeros and poles (in Hz) for mf
%

function [z, p, k] = getZPK(mf)

  z = mf.z;
  p = mf.p;
  k = mf.k;
