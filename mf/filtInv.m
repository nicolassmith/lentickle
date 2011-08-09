%
% mf = filtInv(mf)
%
% returns the inverse of mf
%

function mf = filtInv(mf)

  mf = struct('z', mf.p, 'p', mf.z, 'k', 1 / mf.k);
