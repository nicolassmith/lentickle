% lineAtY(y, varargin)
%  draw a line on the current plot at Y

function lineAtY(y, varargin)

if( length(varargin) == 1 )
  varargin = {'Color', varargin{1}};
end

y = [y(:), y(:)]';
a = axis;
x = repmat(a(1:2), length(y), 1)';
line(x, y, varargin{:});
