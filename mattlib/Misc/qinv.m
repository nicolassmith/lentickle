% a quick, bad, incomplete pseudo-matrix inversion solution to:
%  z = x + M y, find the y which minimizes r = sqrt(z' * z)
%
% DO NOT use this, use pinv

function [y, r, z, n] = qinv(x, m, varargin)

  % deal with args
  if( ~isempty(varargin) )
    y = varargin{1};
  else
    y = zeros(size(m, 2), 1);
  end
  if( length(varargin) > 1 )
    N = varargin{2};
  else
    N = 1000;
  end

  if( length(varargin) > 2 )
    tol = varargin{3};
  else
    tol = 1e-6;
  end

  % scale the tolerance
  xs = x' * x;
  if( xs <= 0 )
    y = zeros(size(m, 2), 1);
    return
  end
  tol = tol * sqrt(xs);
  
  trc = diag(m' * m)

  % search for good y
  for n = 1:N
    % compute problem vector
    z = x + m * y;

    % take quickest descent
    [v, j] = max(abs(z' * m));
    dyj = (z' * m(:, j)) / trc(j);
    y(j) = y(j) - dyj;

    % make sure things are still changing
    if( abs(dyj * trc(j)) < tol )
      break;
    end
  end
  
  % compute residual
  r = sqrt(z' * z);
