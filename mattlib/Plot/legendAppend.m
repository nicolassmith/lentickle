% Append to the legend.
%
%

function legendAppend(strs, varargin)

  [legh, objh, outh, outm] = legend;

  if( iscell(strs) )
    legend({outm{:}, strs{:}}, varargin{:});
  else
    legend(outm{:}, strs, varargin{:});
  end
