%
% y = lowpass(x, nFilt)
%

function y = lowpass(x, nFilt)

  if( nFilt == 0 | length(x) < 2 )
    y = x;
    return
  end

  f = -1 / nFilt;
  a = [2 + (sqrt(2) - f)^2, 2 * f^2 - 8, 2 + (sqrt(2) + f)^2];
  b = f^2 * [1, 2, 1];

  y = filtfilt(b, a, x);
