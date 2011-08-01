%
% mf = filtZPG(mf, g, f)
%
% returns mf with gain g at frequency f (in Hz)
%

function mf = filtZPG(mf, g, f)

  mf.k = mf.k * g / abs(sresp(mf, f));
