%
% h = zresp(mf, f, fs)
% 
% returns the Z-domain frequency response of mf at f (in Hz)
% (See also: freqz)
%

function varargout = zresp(mf, f, fs, varargin);

  % compute response
  sos = getSOS(mf, fs);
  h = sosresp(sos, f, fs);

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
