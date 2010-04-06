% get frequency and Q of a zero or pole
%
% [f, q] = getFQ(z)
%
% root with negative imaginary parts will be ignored

function [f, q] = getFQ(z)

  % init
  a = real(z);
  b = imag(z);

  n = find(b >= 0);
  a = a(n);
  b = b(n);
  
  f = zeros(size(a));
  q = zeros(size(a));

  % real zero or pole
  nr = find(b == 0); 
  q(nr) = 0;
  f(nr) = a(nr);

  % infinite Q
  ni = find(a == 0); 
  q(ni) = Inf;
  f(ni) = b(ni);

  % finite and complex
  nc = find(a ~= 0 & b ~= 0);
  q(nc) = sqrt((b(nc) ./ a(nc)).^2 + 1) / 2;
  f(nc) = 2 * q(nc) .* a(nc);
