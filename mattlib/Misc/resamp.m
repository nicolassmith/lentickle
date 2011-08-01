% Resamples data at given points
% yNew = resamp(xOld, yOld, xNew, nMax = 30, nMin = 2)
%
%

function yNew = resamp(xOld, yOld, xNew, varargin)

  % get optional arguments
  if( length(varargin) > 0 )
    nMax = varargin{1};
  else
    nMax = 30;
  end

  if( length(varargin) > 1 )
    nMin = varargin{2};
  else
    nMin = 2;
  end

  % main loop
  yNew = zeros(length(xNew), 1);
  for n = 1:length(xNew)

    % get interval witdh
    if( n == 1 & n == length(xNew))
      width = xNew(n) / 2;
    elseif( n == 1 )
      width = xNew(n + 1) - xNew(n);
    elseif( n == length(xNew) )
      width = xNew(n) - xNew(n - 1);
    else
      width = (xNew(n + 1) - xNew(n - 1)) / 2;
    end

    % get points to fit
    [xSort, map] = sort(abs(xOld - xNew(n)));
    index = find(xSort < width);

    if( length(index) > nMax )
      index = map(1:nMax);
    elseif( length(index) < nMin )
      index = map(1:nMin);
    else
      index = map(index);
    end

    % resample
    if( length(index) == 0 )
      fit = NaN;
    elseif( length(index) == 1 )
      fit = polyfit(xOld(index), yOld(index), 0);
    elseif( length(index) < 6 )
      fit = polyfit(xOld(index), yOld(index), 1);
    else
      fit = polyfit(xOld(index), yOld(index), 2);
    end
    yNew(n) = polyval(fit, xNew(n));
  end
