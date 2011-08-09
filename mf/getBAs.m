%
% [bs, as] = getBAs(mf)
%
% get S-domain transfer-function numerator and denominator
%

function [bs, as] = getBAs(mf)

  [zs, ps, ks] = getZPKs(mf);
  [bs, as] = zp2tf(zs, ps, ks);
