%
% [m, n] = getMN(index)
%

function [m, n] = getMN(index)

  mn = ceil((sqrt(9.0 + 8.0 * index) - 3.0) / 2.0);
  smn = mn * (mn + 3) / 2;
  m = smn - index;
  n = index - smn + mn;
