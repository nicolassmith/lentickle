% [z, z0] = eigenOpHG(op)
% q = eigenOpHG(op)
%
% find the basis which propagates through op uneffected
% (see also applyOpHG)
%
%% Example:
% q = eigenOpHG(op);
% q1 = applyOpHG(op, q);  % q1 == q

function [z, z0] = eigenOpHG(op)

  % solve quadratic equation
  a = 2 * op(2, 1);
  b = op(1, 1) - op(2, 2);
  c = -op(1, 2);
  
  % q = (b - sqrt(b^2 - 2 * a * c)) / a;
  z = b / a;
  z0 = -sqrt(2 * a * c - b^2) / a;

  % check
  if ~isreal(z0) | z0 <= 0
    error('Unable to find eigen basis');
  end
  
  % return q if only one output argument
  if nargout < 2
    z = z + i * z0;
  end
