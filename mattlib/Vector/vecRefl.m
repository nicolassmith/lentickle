% return vector reflected about vaxis
%   equivalent to -vecRot(v, vaxis, pi), but less costly
% vr = vecRefl(v, vaxis)

function vr = vecRefl(v, vaxis)

  dva = 2 * dot(v, vaxis);
  vr = v - vaxis * dva;
 