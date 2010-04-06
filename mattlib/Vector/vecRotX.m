% return vector rotated about Z-axis
%  if only one argument is given, the rotation
%  matrix and its inverse are returned
%
% vr = vecRotX(v, ang)
% [mr, mi] = vecRotX(ang)

function [vr, mi] = vecRotX(v, ang)

  if nargin == 1
    ang = v;
    cs = cos(ang);
    sn = sin(ang);
    vr = [1 0 0; 0 cs -sn; 0  sn cs];
    mi = [1 0 0; 0 cs  sn; 0 -sn cs];
    return
  end
  
  cs = cos(ang);
  sn = sin(ang);
  vr = [1 0 0; 0 cs -sn; 0  sn cs] * v;
