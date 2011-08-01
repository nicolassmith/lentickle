%
% [yMax, xMax] = peak(x, y, x0, dx)
% find maximum y within dx of x0
% x0 may be a vector
%

function [yMax, xMax] = peak(x, y, x0, dx)

  xMax = zeros(size(x0));
  yMax = zeros(size(x0));
  
  for n = 1:length(x0)
    nFit = find(x < x0(n) + dx/2 & x > x0(n) - dx/2);
    pFit = polyfit(x(nFit), y(nFit), 2);
    xMax(n) = -pFit(2) / (2 * pFit(1));
    yMax(n) = polyval(pFit, xMax(n));

%    plot(x(nFit), y(nFit), 'b', ...
%         x(nFit), polyval(pFit, x(nFit)), 'g', ....
%         xMax(n), yMax(n), 'rx');
%    pause
  end

%  plot(x, y, 'b', xMax, yMax, 'rx')
