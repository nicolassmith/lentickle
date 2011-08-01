%
% mf = filtZPK(z, p, k)
%
% makes a filter (mf) struct from zeros, poles and gain
% (z, p, k).
%
% Zeros and poles are in Hz (i.e. their S-domain counterparts
% are zs = -2 * pi * z, ps = -2 * pi * p).

function mf = filtZPK(z, p, k)

  mf = struct('z', z(:), 'p', p(:), 'k', k);
