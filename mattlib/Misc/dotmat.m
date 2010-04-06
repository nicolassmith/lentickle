% m = dotmat(m)
%
% return a matrix which is the angles between the column
% vectors of the argument matrix

function m = dotmat(m)

  m = diag(1 ./ sqrt(sum(m.^2, 2))) * m;
  m = abs(m' * m);
  n = 1./sqrt(diag(m));
  m = round(1800 * acos(diag(n) * m * diag(n)) / pi) / 10;
