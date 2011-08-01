%
% h = sfft(dat, f)
% [amp, phase] = sfft(dat, f)
%
% output is either complex h or amplitude and phase (in degrees)

function varargout = sfft(dat, f)

  N = floor((dat(end, 1) - dat(1,1)) * f)
  n = find(dat(:,1) < (dat(1,1) + N / f));
  t = dat(n, 1);
  x = dat(n, 2) - mean(dat(n,2));

  omega = 2 * pi * f;

  s = sin(omega * t);
  c = cos(omega * t);

  aSin = sum(x .* s) / sum(s .* s);
  aCos = sum(x .* c) / sum(c .* c);

  h = aCos + i * aSin;
  amp = sqrt(aSin^2 + aCos^2);
  phase = 180 * atan2(aCos, aSin) / pi;
  
  if( nargout == 1 )
    varargout{1} = h;
  elseif( nargout == 2 )
    varargout{1} = amp;
    varargout{2} = phase;
  end
