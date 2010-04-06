% [z0, z1, z2] = cavHG(L, R1, R2)
%
% Given the length of a cavity, and the radii
% of curvature of the mirrors, this function
% returns the Rayleigh Range of the beam, z0,
% and the positions of the mirrors relavitve
% to the waist (z1 and z2).

function [z0, z1, z2] = cavHG(L, R1, R2)

  LR1 = R1 - L;
  LR2 = R2 - L;
  LRR = LR1 + LR2;

  z0 =  sqrt(L * LR1 * LR2 * (R1 + R2 - L)) / abs(LRR);
  z1 = -L * LR2 / LRR;
  z2 =  L * LR1 / LRR;

  % make vector output
  if nargout < 2
    z0 = [z0, z1, z2];
  end
