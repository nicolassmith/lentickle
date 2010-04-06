% modelerBode(dat, legendList, cols, <scale>)
%
% Inputs:
% dat		NxM		the data
% legendList	N cell		the name of each data column
% cols		1xN		either the columns to plot, or a string
%                       	 found in the legend of all columns to plot
% scale		0x0, 1x1 or 1xN	the data is scaled by this vector, an empty
%				 scale, [], scales automatically

function modelerBode(dat, legendList, cols, varargin)

  % get cols
  if( isstr(cols) )
    str = cols;
    cols = [];
    for n = 1:length(legendList)
      if( strcmp(legendList{n}(end-3:end), '_amp') & ...
          length(findstr(str, legendList{n})) > 0 )
        cols = [cols, n];
      end
    end
  end
  cols


  % limit dat
  [f, n] = sort(dat(:, 1));
  amp = dat(n, cols(:));
  phi = dat(n, cols(:) + 1);
  
  % scale
  if( length(varargin) > 0 )
    if( length(varargin{1}) == size(amp, 2) )
      scale = varargin{1};
    elseif( length(varargin{1}) == 0 )
      scale = 10.^(-round(log10(max(abs(amp)))));
      scale = scale / min(scale);
    else
      scale = varargin{1}(1) * ones(1, size(amp, 2));
    end
    if( length(varargin) > 1 )
      varargin = varargin(2:end);
    else
      varargin = {};
    end
  else
    scale = ones(1, size(amp, 2));
  end
  amp = amp * diag(scale);


  % generate legend
  newLegendList = {};
  for n = 1:length(cols)
    if( scale(n) == 1 )
      str = legendList{cols(n)}(1:end-4);
    else
      str = sprintf('%s * %g', legendList{cols(n)}, scale(n));
    end
    newLegendList = {newLegendList{:}, str};
  end

  % display
  subplot(2, 1, 1);
  loglog(f, amp, varargin{:});
  xlabel('f (Hz)');

  subplot(2, 1, 2);
  semilogx(f, unwrap(phi) * 180 / pi, varargin{:});
  xlabel('f (Hz)');
  ylabel('phase (degree)');

  %legend(newLegendList);
