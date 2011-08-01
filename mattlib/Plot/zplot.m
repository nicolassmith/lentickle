%
% zplot(f, h)
%
% log plot of magnitude and phase of a complex number
%

function zplot(f, h, varargin)

  subplot(2, 1, 2)
  plot(f, 180 * unwrap(angle(h)) / pi, varargin{:})
  ylabel('phase (degrees)')
  grid on

  subplot(2, 1, 1)
  plot(f, abs(h), varargin{:})
  ylabel('magnitude')
  grid on

