%
% [R, w] = beamRW(z0, z, lambda)
%
% where z0 and z are the Rayleigh Range and distance past
% the waist at a beam cross-section
%

function [R, w] = beamRW(z0, z, lambda)

  zb = z ./ z0;
  wb = z0 .* (1 + zb.^2);
  w  = sqrt(wb * lambda / pi);
  if zb == 0
    R = Inf;
  else
    R = wb ./ zb;
  end
