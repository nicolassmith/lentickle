%
%
%

function [amp, phase] = modmatrix(dat, s, tStart)

  m = find(dat(:,1) > tStart);

  N = length(s);
  amp = zeros(size(s));
  phase = zeros(size(s));
  for n = 1:N
    [amp(n), phase(n)] = sfft(dat(m, [1, s(n).col]), 100);
    amp(n) = amp(n) * 1e4;
    if( phase(n) > 0 )
      phase(n) = phase(n) - 180;
      amp(n) = amp(n) * -1;
    end
    fprintf('%s -> %g, %g\n', s(n).name, amp(n), phase(n))
  end
