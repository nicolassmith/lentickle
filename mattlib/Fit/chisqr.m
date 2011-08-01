% weighted chi squared difference between data and function
%
%
% The function is called as y = fun(param, xData, ...).
%
% Input:
% Name        Size        Description
% subparam    1xP         subset of function parameters
% fun         1x?         function name (string)
% param       0x0 or 2xP  full set of function parameters and usage mask
% data        Nx2 or Nx3  [xData; yData] or [xData; yData; yError]
% ...                     other stuff to send to fun
%
% Output:
% Name        Size        Description
% chi         1x1         chi squared

function chi = chisqr(subparam, fun, param, data, varargin);

% construct yError
if( size(data, 2) > 2 )
  yError = data(:, 3);
else
  yError = ones(size(data, 1), 1);
end

% consturct param
if( size(param, 1) == 2 )
  funparam = param(1, :);
  funparam(find(param(2, :))) = subparam;
else
  funparam = subparam;
end

% compute chi squared
y = feval(fun, funparam, data(:, 1), varargin{:});
chi = sum(sum( (abs(data(:, 2) - y) ./ yError).^2 ));
