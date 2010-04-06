%
% mf = filtFit(h, f, nMax, fMax)
%
% h is amplitude at f in Hz
% find an S-domain transfer function for h
% (additional arguments are passed to invfreqs)
% 

function mf = filtFit(h, f, nMax, fMax, err, varargin)

  nb = nMax;
  na = nMax;
  done = 0;

  wMax = 2 * pi * fMax;

  warnState = warning;
  warning off
  while( ~done )
    [b, a] = invfreqs(h, 2 * pi * f, nb, na, varargin{:});

    bMax = max((wMax.^-(0:nb)) .* abs(b));
    aMax = max((wMax.^-(0:na)) .* abs(a));
    if( nb > 0 & abs(b(1)/bMax) < err )		% extra b's
      nb = nb - 1;
    elseif( na > 0 & abs(a(1)/aMax) < err )	% extra a's
      na = na - 1;
    else
      [z, p, k] = tf2zp(b, a);
      zz = repmat(z, size(p'));
      pp = repmat(p', size(z));
      v = (abs((zz - pp)./sqrt(zz .* pp)) < err);
      if( ~isempty(find(v)) )			% z-p pairs
        nb = nb - 1;
      else
        done = 1;
      end
    end
  end
  warning(warnState);

  mf = filtBAs(b, a);

%return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display

  h1 = sresp(mf, f);

  zplotlog(f, [h, h1])
  z = mf.z
  p = mf.p
  k = mf.k

  display('Press ank key...');
  pause

