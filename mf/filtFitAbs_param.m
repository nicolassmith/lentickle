%
% [z, p, k] = filtFitAbs_param(param, nz, np, nr, gDC, nzh, nph)
%
% length(param) == 2 * (nz + np +nr)
% param(1:nz) - real parts of complex zeros
% param(nz + (1:nz)) - imag parts of complex zeros
% param(2*nz + (1:np)) - real parts of complex poles
% param(2*nz + np + (1:np)) - imag parts of complex zeros
% param(2*nz + 2*np + (1:nr)) - real zeros
% param(2*nz + 2*np + nr + (1:nr)) - real poles
%

function [z, p, k] = filtFitAbs_param(param, nz, np, nr, gDC, nzh, nph)

  param = param(:);

  % extract zeros and poles from param
  z = param(1:nz) + i * param(nz + (1:nz));
  z = [z; conj(z)];
  param = param(2*nz+1:end);
 
  p = param(1:np) + i * param(np + (1:np));
  p = [p; conj(p)];
  param = param(2*np+1:end);

  z = [z; param(1:nr)];
  p = [p; param(nr+1:end)];

  % DC gain
  g = (abs(prod(z) / prod(p)) / gDC)^(1/(nzh+nph));
  z = [z; ones(nzh, 1) / g];
  p = [p; ones(nph, 1) * g];

  % high freq gain
  k = 1;
