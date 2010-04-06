% Log plot of magnitude (in db) and phase (in degrees) of a complex vector.
%
% zplotdb(f, h)

function zplotdb(f, h, varargin)

  % phase
  subplot(2, 1, 2)
  semilogx(f, 180 * angle(h) / pi, varargin{:})
  ylabel('phase (degrees)')
  grid on

  % magnitude (done second so that it is "selected")
  subplot(2, 1, 1)
  semilogx(f, 20 * log10(abs(h)), varargin{:})
  ylabel('magnitude (dB)')
  grid on

