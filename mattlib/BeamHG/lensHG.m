%
% [phi, z0, z] = lensHG(f, d, z0, z)
%
% f is an N element array of focal lengths
% d is an N + 1 element array of distances between lenses
%   (and one on either end)
%
% z0 and z are the HG basis parameters (input and output)
% phi is the accumulated guoy phase
%
% (see also lensPlot)

function [phi, z0, z, pv, bv] = lensHG(f, d, z0, z)

  % check vector lengths
  if( length(d) ~= length(f) + 1 )
    error('length(d) ~= length(f) + 1');
  end
  pv = zeros(size(d));
  bv = zeros(size(d));

  % compute phase
  b = z + i * z0;				% init basis
  phi = -atan(real(b) / imag(b));		% init guoy phase

  for n = 1:length(f)
    b = b + d(n);				% propagate
    phi = phi + atan(real(b) / imag(b));	% add pre-lens guoy
    
    pv(n) = phi;				% record phi
    bv(n) = b;					% record b
    if f(n) ~= 0.0
      b = b / (1 - b / f(n));			% apply lens
    end
    phi = phi - atan(real(b) / imag(b));	% sub post-leng guoy
  end

  b = b + d(end);				% propagate
  phi = phi + atan(real(b) / imag(b));		% add final guoy

  pv(end) = phi;				% record phi
  bv(end) = b;					% record b

  z = real(b);
  z0 = imag(b);
