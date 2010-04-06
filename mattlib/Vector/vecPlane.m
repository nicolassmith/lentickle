% return time to crossing of a particle with
%  position p and velocity v and a plane which
%  passes through the origin and has normal vn.
%  A negative time indicates that the particle
%  will not, but might have, crossed the plane.
%    isBack = dot(p, vn) < 0
%
% [tc, isBack] = vecPlane(p, v, vn)

function [tc, isBack] = vecPlane(p, v, vn)

  dpn = dot(p, vn);
  dvn = dot(v, vn);

  isBack = dpn < 0;

  ninf = find(dpn ~= 0 & dvn == 0);
  nok = find(dpn ~= 0 & dvn ~= 0);
  
  tc = dpn;
  tc(ninf) = Inf;
  tc(nok) = -dpn(nok) ./ dvn(nok);
