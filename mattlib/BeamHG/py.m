%
% returns normalized (w/sqrt(2)=1) Hermite Gaussian beam
%

function data = py(x,y,order,itime,dat)

if size(order,2) == 1
  order_min = 0;
  order_max = order;
else
  order_min = order(1,1);
  order_max = order(1,2);
end
if order_min < 0
  order_min = 0;
end
if order_max > 3
  order_max = 3;
end

dataR = zeros(size(x, 2), size(y, 2));
dataI = zeros(size(x, 2), size(y, 2));

xn = sqrt(2) * x;
yn = sqrt(2) * y;
for nm = order_min : order_max
  for m = 0 : nm
    n = nm - m;
    coeff = ( Hermite(m, xn') * Hermite(n, yn) ) ...
      / sqrt( ( 2^(n+m) * gamma(n+1) * gamma(m+1) ) );
    [itime, n, m, nmmap(m, n)*2 + 1]
    dataR = dataR + coeff * dat(itime,nmmap(m,n)*2+1);
    dataI = dataI + coeff * dat(itime,nmmap(m,n)*2+2);
  end;
end;
data = (dataR.^2 + dataI.^2) .* (exp(-x.^2)' * exp(-y.^2)).^2;

return

function index = nmmap( m, n )

mn = m + n;
index = mn * (mn + 3) / 2 - m;

return

      

