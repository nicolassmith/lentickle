%
% mf = filtZPKs(zs, ps, ks)
%
% makes a filter (mf) struct from S-domain zeros, poles
% and gain (zs, ps, ks).
%

function mf = filtZPKs(zs, ps, ks)

  z = zs / (-2 * pi);
  p = ps / (-2 * pi);
  k = (2 * pi)^(length(zs) - length(ps)) * ks;
  mf = filtZPK(z, p, k);
