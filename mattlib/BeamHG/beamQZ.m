% q = beamQZ(R, w, lambda)
% [z, z0] = beamQZ(R, w, lambda)
%
% where R and w are the wave front radius of curvature
% and beam width at a beam cross-section

function [z, z0] = beamQZ(R, w, lambda)

  wb = w.^2 * pi / lambda;

  zb = wb ./ R;
  z0 = wb ./ (1 + zb.^2);
  z = zb * z0;

  % return q if only one output argument
  if nargout < 2
    z = z + i * z0;
  end
