% breaks an array into the first N consecutive elements (first N elements
% which satisfy the relation x(n + 1) == x(1) + delta * n), and the rest.
%
% [head, tail] = consec(x, [delta])
%
% Input:
% Name        Size        Description
% x           Px1         array of integers
% delta       1x1         difference ( defualt == 1 )
%
% Output:
% Name        Size        Description
% head        Nx1        first N consecutive elements
% tail        Mx1        the rest of the array

function [head, tail] = consec(x, varargin)

if( length(varargin) > 0 )
  delta = varargin{1};
else
  delta = 1;
end

if( isempty(x) )
  head = [];
  tail = [];
  return
end

for n = 1:(length(x) - 1)
  if( x(n + 1) ~= x(1) + delta * n )
    head = x(1:n);
    tail = x((n + 1):end);
    return;
  end
end

head = x;
tail = [];
