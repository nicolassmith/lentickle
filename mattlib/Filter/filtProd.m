%
% mf = filtProd(mf0, mf1, ...)
%
% return the product of argument filters
%

function mf = filtProd(varargin)

  z = [];
  p = [];
  k = 1;
  for n = 1:length(varargin)
    [zn, pn, kn] = getZPK(varargin{n});
    z = [z; zn];
    p = [p; pn];
    k = k * kn;
  end

  mf = filtZPK(z, p, k);
