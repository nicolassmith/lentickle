% returns the frequency response of a
% Z-domain second-order-section matrix
% (see getSOS, and tf2sos)
% 
% h = sosresp(sos, f, fs)

function h = sosresp(sos, f, fs);

  digw = (2 * pi / fs) .* f;	% Convert from Hz to rad/sample
  s = exp(-i * digw);		% S for this calculation 
  ss = s .* s;			% S^2

  % compute response
  h = ones(size(f));
  for n = 1:size(sos, 1)
    h = h .* (sos(n, 1) + sos(n, 2) .* s + sos(n, 3) .* ss) ./ ...
             (sos(n, 4) + sos(n, 5) .* s + sos(n, 6) .* ss);
  end

  % was this, but it didn't work as well
  % h = h .* freqz(sos(n, 1:3), sos(n, 4:6), f, fs);
