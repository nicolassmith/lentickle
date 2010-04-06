% return vector rotated about vaxis
%  if only one argument is given, the rotation
%  matrix and its inverse are returned
%  (see also vecRotX, vecRotY and vecRotZ)
%
% vr = vecRot(v, vaxis, ang)
% [mr, mi] = vecRot(vaxis, ang)

function [vr, mi] = vecRot(v, vaxis, ang)

  if nargin == 2
    ang = vaxis;
    vaxis = v;
  end

  th = atan2(vaxis(2), vaxis(1));
  [m1, m5] = vecRotZ(-th);

  v0 = m1 * vaxis;
  phi = atan2(v0(1), v0(3));
  [m2, m4] = vecRotY(-phi);
  [m3, m3i] = vecRotZ(ang);
  
  if nargin == 2
    vr = m5 * m4 * m3 * m2 * m1;
    mi = m5 * m4 * m3i * m2 * m1;
  else
    vr = m5 * m4 * m3 * m2 * m1 * v;
  end