% fits a function to data
%
% The fit minimizes the squared difference between the data and the function
% result y = fun(param, xData, ...).
% [param, chi] = fitFun(fun, param0, data, [options, ...])
%
% Input:
% Name        Size        Description
% fun         1x?         function name (string)
% param0      1xP         initial function parameters
% data        Nx2 or Nx3  [xData, yData] or [xData, yData, yError]
% options     1x?         options passed to fmins
% ...                     other stuff to send to fun
%
% Output:
% Name        Size        Description
% param       1xP         final function parameters
% chi         1x1         final chi squared per degree of freedom

function [param, chi] = fitFun(fun, param0, data, varargin)

% get options from varargin
if( length(varargin) > 0 )
  opt = varargin{1};
else
  opt = optimset;
end

% get rest of varargin
if( length(varargin) > 1 )
  varargin = varargin(2:end);
else
  varargin = {};
end

% break out selected paramters
if( size(param0, 1) == 2 )
  n = find(param0(2, :));
else
  n = 1:size(param0, 2);
end
subparam = param0(1, n);

% fit
subparam = fminsearch('chisqr', subparam, opt, fun, param0, data, varargin{:});

% reconstruct param
param = param0;
param(1, n) = subparam;

chi = chisqr(subparam, fun, param, data, varargin{:});
chi = chi / (length(data(:, 2)) - length(subparam));
