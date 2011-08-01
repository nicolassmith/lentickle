% Plot an open-loop transfer function.
% (If the phase doesn't look right, your loop may have the wrong sign.)
%
% plotLoop(f, h)

function plotLoop(f, h, varargin)

  % squeeze inputs
  f = f(:);
  h = h(:);

  % get magnitude and phase
  mag = abs(h);
  phi = 180 * unwrap(angle(h)) / pi;

  % find unity gain frequency and phase margin
  n = find(mag(2:end) < 1);				% points below UG
  if( isempty(n) )
    ugf = NaN;
    pm = NaN;
  else
    % find points around unity
    n = n + 1;						% points below UG
    n = [n(1) - 1; n(1)];				% bare minimum
    m = find(mag(1:end) < 1.5 & mag(1:end) > 1/1.5);	% a few more points?
    m = unique([n; m]);					% this also sorts

    % fit magnitude around unity
    pf = polyfit(log(f(m)), log(mag(m)), 1);
    ugf = exp(roots(pf));

    % compute phase margin
    pm = spline(f, phi, ugf);

    % try to fix phase wrap
    dphi = pm - 90 * pf(1);			% approximate phase offset
    phi = phi - 360 * round(dphi / 360);	% use closest 360 degree offset
    pm = pm - 360 * round(dphi / 360);		% also for phase margin

  end

  % plot phase
  n = find(phi < -300);
  phi(n) = NaN;

  subplot(2, 1, 2)
  semilogx(f, phi - 180, varargin{:})
  ylabel('phase (degrees)')
  grid on

  subplot(2, 1, 2)
  line([min(f) max(f)], [-180, -180], 'Color', 'r')
  line([ugf ugf], [0, -180], 'Color', 'r')
  title(sprintf('phase margin = %0.3g^o', pm))

  % plot magnitude
  n = find(mag < 1e-2);
  mag(n) = NaN;

  subplot(2, 1, 1)
  loglog(f, mag, varargin{:})
  ylabel('magnitude')
  grid on

  line([min(f) max(f)], [1, 1], 'Color', 'r')
  line([ugf ugf], [0.1, 10], 'Color', 'r')
  title(sprintf('UGF = %g Hz', ugf))
