%
% [val, index] = nmax(x, N)
%
% returns first N maxima in x
% (inefficient)
%
function [val, index] = nmax(x, N)

val   = zeros(N, 1);
index = zeros(N, 1);

for n = 1:N
  
  [val(n), index(n)] = max(x);

  j = index(n);
  while ( j < length(x) & x(j + 1) < x(j) )
    j = j + 1;
  end

  k = index(n);
  while ( k > 1 & x(k - 1) < x(k) )
    k = k - 1;
  end

  low = min(x([j, k]));
  x(k:1:j) = low;
end


return;
