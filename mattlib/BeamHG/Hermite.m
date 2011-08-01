%
% return Hermite polynomial
%

function data = Hermite( m, x )
switch m
  case 0,
    data(1:size(x,1),1:size(x,2)) = 1;
  case 1,
    data = 2*x;
  case 2,
    data = -2 + 4*x.*x;
  case 3,
    data = ( 8*x.*x - 12 ) .* x;
  case 4,
    x2 = x.*x;
    data = (16*x2 - 48).*x2 + 12;
  case 5,
    x2 = x.*x;
    data = ((32*x2-160).*x2 + 120).*x;
  otherwise
    data = 2 * x .* Hermite(m - 1, x) - 2 * (m - 1) * Hermite(m - 2, x);
end

