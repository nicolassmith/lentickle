%
% [bx, by] = fieldParam(f)
% bx = f(1:3);  % X [w0, z0, z]
% by = f(4:6);  % Y [w0, z0, z]
%

function [bx, by] = fieldParam(f)

  % beam params
  bx = f(1:3);  % X [w0, z0, z]
  by = f(4:6);  % Y [w0, z0, z]
