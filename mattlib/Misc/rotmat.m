% returns a 2x2 rotation matrix for the given angle (radians)
%
% m = rotmat(phi)

function m = rotmat(phi)

  c = cos(phi);
  s = sin(phi);
  m = [c s; -s c];
