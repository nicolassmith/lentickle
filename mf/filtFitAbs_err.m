%
% err = filtFitAbs_err(param, a, f, nz, np, nr, gDC)
%
% length(param) == 2 * (nz + np +nr)
% param(1:nz) - real parts of complex zeros
% param(nz + (1:nz)) - imag parts of complex zeros
% param(2*nz + (1:np)) - real parts of complex poles
% param(2*nz + np + (1:np)) - imag parts of complex zeros
% param(2*nz + 2*np + (1:nr)) - real zeros
% param(2*nz + 2*np + nr + (1:nr)) - real poles
%

function err = filtFitAbs_err(param, a0, f, nz, np, nr, gDC, nzh, nph)

  % compute ZPK from params
  [z, p, k] = filtFitAbs_param(param, nz, np, nr, gDC, nzh, nph);

  % compute response
  [b, a] = zp2tf(-z, -p, k);
  h = polyval(b, i * f) ./ polyval(a, i * f);

  % compute error
  err = sum(log(a0 ./ abs(h)).^2);
