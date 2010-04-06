%
% mf = filtZPG(z, p, g, f)
%
% makes a filter (mf) struct as in "filtZPK", but sets k
% such that the S-domain gain at f (in Hz) is g
%

function mf = filtZPG(z, p, g, f)

  mf = filtGain(filtZPK(z, p, 1), g, f);
