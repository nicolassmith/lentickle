% sys = fitZPK(data, z, p, k)
%

function [z, p, k, chi] = fitZPK(data, z, p, k)

  param0 = [z, p, k];
  nZero = length(z);
  options = foptions;
  options(14) = 1e4;

  [param, chi] = fitFun('funZPK', param0, data, options, nZero);

  z = param(1:nZero);
  p = param((1 + nZero):(end - 1));
  k = param(end);
