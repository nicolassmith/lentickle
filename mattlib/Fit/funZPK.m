% h = funZPK(param, f, <nZero>)
% for use with fitFun
% param should be nZero zeros (assumed to be 0 if not given)
% followed by some number of poles followed by the gain.

function h = funZPK(param, f, varargin)

  if( length(varargin) > 0 )
    nZero = varargin{1};
  else
    nZero = 0;
  end

  z = param(1:nZero);
  p = param((1 + nZero):(end - 1));
  k = param(end);
  h = squeeze(freqresp(zpk(z, p, k), (2*pi)*f));
