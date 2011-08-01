% return normalized vector
%
% vn = vecNorm(v)

function vn = vecNorm(v)

  d = sqrt(sum(v.^2, 1));
  vn = v ./ repmat(d, size(v, 1), 1);
