% for interpolating log-log data (e.g., transfer functions)

function yy = logspline(x, y, xx)

  p = spline(log(x), unwrap(angle(y)), log(xx));
  m = spline(log(x), log(abs(y)), log(xx));
  yy = exp(m + i * p);
