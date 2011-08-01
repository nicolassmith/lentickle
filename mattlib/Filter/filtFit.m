%
% mf = filtFit(h, f, nb, na)
%
% h is amplitude at f in Hz
% find an S-domain transfer function for h
% (additional arguments are passed to invfreqs)
% 

function mf = filtFit(h, f, nb, na, varargin)

  [b, a] = invfreqs(h, 2 * pi * f, nb, na, varargin{:});
  mf = filtBAs(b, a);

  return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display

  h1 = sresp(mf, f);

  zplotlog(f, [h, h1])
  z = mf.z
  p = mf.p
  k = mf.k

  display('Press ank key...');
  drawnow
%  pause

