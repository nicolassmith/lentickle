% return vector rotated about Z-axis
%  if only one argument is given, the rotation
%  matrix and its inverse are returned
%
% vr = vecRotZ(v, ang)
% [mr, mi] = vecRotZ(ang)

function [vr, mi] = vecRotZ(v, ang)

  if nargin == 1
    ang = v;
    cs = cos(ang);
    sn = sin(ang);
    vr = [cs -sn 0;  sn cs 0; 0 0 1];
    mi = [cs  sn 0; -sn cs 0; 0 0 1];
    return
  end
  
  cs = cos(ang);
  sn = sin(ang);
  vr = [cs -sn 0;  sn cs 0; 0 0 1] * v;
