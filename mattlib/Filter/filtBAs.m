%
% mf = filtBAs(bs, as)
%
% makes a filter (mf) struct from S-domain
% numerator and denominator (bs, as).
%

function mf = filtBAs(bs, as)

  [zs, ps, ks] = tf2zp(bs, as);
  mf = filtZPKs(zs, ps, ks);
