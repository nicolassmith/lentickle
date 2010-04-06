% modelerPlot(t, dat, legendList, cols, <scale>)
%
% Inputs:
% t		Nx1		the abscissa
% dat		NxM		the data
% legendList	M cell		the name of each data column
% cols		1xL		either the columns to plot, or a string
%                       	 found in the legend of all columns to plot
% scale		0x0 or 1xL	the data is scaled by this vector, an empty
%				 scale, [], scales automatically

function modelerPlot(t, dat, legendList, cols, varargin)

  % limit dat
  y = dat(:, cols(:));
  
  % scale
  if( length(varargin) > 0 )
    if( length(varargin{1}) == size(y, 2) )
      scale = varargin{1};
    elseif( length(varargin{1}) == 0 )
      maxY = max(abs(y));
      isScalable = isfinite(maxY) .* gt(maxY, 0);
      maxY = maxY .* isScalable + max(maxY) .* ~isScalable;
      scale = 10.^(-fix(log10(maxY)));
      scale = scale / min(scale);
      scale = scale .* isScalable + ~isScalable;
    else
      scale = varargin{1}(1) * ones(1, size(y, 2));
    end
    if( length(varargin) > 1 )
      varargin = varargin(2:end);
    else
      varargin = {};
    end
  else
    scale = ones(1, size(y, 2));
  end
  y = y * diag(scale);

  % generate legend
  newLegendList = {};
  for n = 1:length(cols)
    if( scale(n) == 1 )
      str = legendList{cols(n)};
    else
      str = sprintf('%s * %g', legendList{cols(n)}, scale(n));
    end
    newLegendList = {newLegendList{:}, str};
  end

  % display
  plot(t, y, varargin{:});
  legend(newLegendList{:});
