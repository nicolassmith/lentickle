% lineAtX(x, varargin)
%  draw a line on the current plot at X

function lineAtX(x, varargin)

if( length(varargin) == 1 )
  varargin = {'Color', varargin{1}};
end

x = [x(:), x(:)]';
a = axis;
y = repmat(a(3:4), length(x), 1)';
line(x, y, varargin{:});
