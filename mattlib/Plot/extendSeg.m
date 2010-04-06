% Extended a segment to the midpoint between end points and the points
% just outside of the segment.  This allow several segments to be ploted and
% appear continuous.
%
%
% Input:
% Name        Size        Description
% x           NxM         M column vectors to be extended
% n           Px1         indices of each vector to include
%
% Output:
% Name        Size        Description
% y           (P+2)xM     extended result

function y = extendSeg(x, n)

if( length(n) < 1 )
  y = [];
  return
end

y = zeros(length(n) + 2, size(x, 2));

if( n(1) == 1 )
  y(1, :) = x(1, :);
else
  y(1, :) = (x(n(1), :) + x(n(1) - 1, :)) / 2;
end

if( n(end) == size(x, 1) )
  y(end, :) = x(end, :);
else
  y(end, :) = (x(n(end), :) + x(n(end) + 1, :)) / 2;
end

y(2:(end - 1), :) = x(n, :);
