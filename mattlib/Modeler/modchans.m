%
% s = modchans(lgnd, basename, namepat, unit, scale, colors)
%

function s = modchans(lgnd, base, chans, names, unit, scale, colors, varargin)

  % set hint
  if( length(varargin) > 0 )
    chint = varargin{1};
  else
    chint = 1:length(lgnd);
  end

  % initialize structure array
  N = length(chans);
  s = repmat(struct('name', [], 'unit', unit, 'expr', scale, ...
                    'col', [], 'args', []), 1, N);

  % find channels
  for n = 1:N
    col = chint(strmatch([base chans{n}], lgnd(chint), 'exact'));

    if( isempty(col) )
      warning(['Unable to find channel "' base chans{n} '"']);
    elseif( length(col) > 1 )
      lgnd{col}
      warning(['Multiple matches for channel "' base chans{n} '"']);
    end      

    s(n).name = names{n};
    s(n).col = col;
    s(n).args = colors(n);
  end
