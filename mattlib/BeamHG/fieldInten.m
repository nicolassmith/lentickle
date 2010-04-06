%
% [I, x, y] = fieldInten(f, [x, y])
%
% returns I = intensity of Hermite Gaussian beam
%
% x, y are normalized such that f00 = 1 => I = amp^2 = exp(-2) @ (1, 0)
%  this means that the waist size is always 1
%
% I is normalized such that f00 = 1 => I = 1 @ (0, 0)
%  this is off by 2/pi from the standard normalization
%

function [I, x, y] = fieldInten(f, varargin)

  if( length(varargin) < 2 )
    x = -2:0.04:2;
    y = -2:0.04:2;
  else
    x = varargin{1};
    y = varargin{2};
  end

  % init
  amp = zeros(length(y), length(x));
  xn = sqrt(2) * x;
  yn = sqrt(2) * y;

  guoyX = atan(f.x.z / f.x.z0);
  guoyY = atan(f.y.z / f.y.z0);
  for index = 1:length(f.a)
    [m, n] = getMN(index - 1);
    guoy = guoyX * (m + 0.5) + guoyY * (n + 0.5);
    coeff = Hermite(n, yn') * Hermite(m, xn) * ...
            (exp(i * guoy) / sqrt(2^(n+m) * gamma(n+1) * gamma(m+1)));
    amp = amp + coeff * f.a(index);
  end
  I = (abs(amp) .* (exp(-y.^2)' * exp(-x.^2))).^2;
