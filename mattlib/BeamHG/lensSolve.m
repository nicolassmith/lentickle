% d = lensSolve(z0a, z0b, f1, f2, nFix, dFix)
% [d1, d2, d3] = lensSolve(z0a, z0b, f1, f2, nFix, dFix)
%
% finds the positions of two lenses with focal lengths f1 and f2 that
% convert a beam with z0a beam with z0b.  There are three distances
% (fist waits to fist lens = d1, between lenses = d2, second lens to
% second waits = d3), only two of which are constrained by this
% solution.  nFix {1, 2, 3} determines which distance is fixed and
% dFix sets the value of that distance.

function [d1, d2, d3] = lensSolve(z0a, z0b, f1, f2, nFix, dFix)

  % prepare
  c1 = 1 / f1;
  c2 = 1 / f2;
  
  % compute d1, d2 and d3
  switch nFix
    case 1
      d1 = dFix;
      d1a = dFix;
      a = (1 - c1 * d1)^2 + (c1 * z0a)^2;
      b = sqrt( a / (c2^2 * z0a * z0b) - 1 ) * sign(c1) * sign(c2);
  
      d2 = f1 + f2 + (d1 - f1 - z0a * b) / a;
      d3 = f2 - z0b * b;
      d2a = f1 + f2 + (d1 - f1 + z0a * b) / a;
      d3a = f2 + z0b * b;
    case 2
      d2 = dFix;
      d2a = dFix;
      a = c1 + c2 - c1 * c2 * d2;
      b = sqrt( 1 / (a^2 * z0a * z0b) - 1 ) * sign(c2);
  
      d1 = (1 - c2 * d2) / a + z0a * b;
      d3 = (1 - c1 * d2) / a + z0b * b;
      d1a = (1 - c2 * d2) / a - z0a * b;
      d3a = (1 - c1 * d2) / a - z0b * b;
    case 3
      d3 = dFix;
      d3a = dFix;
      a = (1 - c2 * d3)^2 + (c2 * z0b)^2;
      b = sqrt( a / (c1^2 * z0a * z0b) - 1 );
  
      d2 = f1 + f2 + (d3 - f2 + z0b * b) / a;
      d1 = f1 + z0a * b;
      d2a = f1 + f2 + (d3 - f2 - z0b * b) / a;
      d1a = f1 - z0a * b;
    otherwise
      error('nFix must be 1, 2 or 3')
  end
  
  % make output
  if nargout < 2
    d1 = [d1, d2, d3, sum([d1, d2, d3]); d1a, d2a, d3a, sum([d1a, d2a, d3a])];
  end
