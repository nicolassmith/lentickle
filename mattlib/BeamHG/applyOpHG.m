%
%
%

function q = applyOpHG(op, q)

  q = op * [q; 1];
  q = q(1) / q(2);
