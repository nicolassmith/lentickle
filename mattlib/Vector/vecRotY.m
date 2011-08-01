% return vector rotated about Y-axis
%  if only one argument is given, the rotation
%  matrix and its inverse are returned
%
% vr = vecRotY(v, ang)
% [mr, mi] = vecRotY(ang)

function [vr, mi] = vecRotY(v, ang)

  if nargin == 1
    ang = v;
    cs = cos(ang);
    sn = sin(ang);
    vr = [cs 0  sn; 0 1 0; -sn 0 cs];
    mi = [cs 0 -sn; 0 1 0;  sn 0 cs];
    return
  end
  
  cs = cos(ang);
  sn = sin(ang);
  vr = [cs 0  sn; 0 1 0; -sn 0 cs] * v;
