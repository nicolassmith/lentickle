%
% h = sresp(mf, f)
% 
% returns the S-domain frequency response of mf at f (in Hz)
% (See also: freqs)
%

function varargout = sresp(mf, f, varargin);

  % compute response
  [b, a] = zp2tf(-mf.z, -mf.p, mf.k);
  h = polyval(b, i * f) ./ polyval(a, i * f);

  % check for infinities
  n = find(isinf(f));
  if( ~isempty(n) )
    if( length(mf.p) > length(mf.z) )
      h(n) = 0;
    elseif( length(mf.p) < length(mf.z) )
      h(n) = mf.k * Inf;
    else
      h(n) = mf.k;
    end
  end

  % if no output, display
  if( nargout == 0 )
    zplotlog(f, h, varargin{:});
  else
    varargout{1} = h;
  end
