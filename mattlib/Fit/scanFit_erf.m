% err = scanFit_erf(zz, x, dw, lambda)

function err = scanFit_erf(zz, x, dw, lambda)

  [R, w] = beamRW(zz(2), zz(1) - x, lambda);
  %w = w * exp(zz(3));
  err = sum(sum((dw - repmat(w, 1, size(dw, 2))).^2));
  