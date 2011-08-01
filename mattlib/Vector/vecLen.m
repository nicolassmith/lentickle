% return length of a vector
%
% len = vecLen(v)

function len = vecLen(v)

  len = sqrt(sum(v.^2, 1));
