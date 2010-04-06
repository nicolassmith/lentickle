%
% f = matchHG(z01, z1, z02, z2)
%

function f = matchHG(z01, z1, z02, z2)

  b1 = z1 + i * z01;				% input basis
  b2 = z2 + i * z02;				% output basis

  f = (b1 * b2) / (b2 - b1);
