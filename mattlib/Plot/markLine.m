% Put a marker over a line in a noise spectrum.
%
% markLine(f, a, fLine, df, mark)

function markLine(f, a, fLine, df, mark)

  N = length(fLine);
  dfLine = zeros(N, 1);
  dfLine(:) = df;		% expand scalar df

  % measure line amplitudes
  aLine = zeros(N, 1);
  for n = 1:N
    [aLine(n), snr] = getLineAmp(f, a, fLine(n), dfLine(n));
    if(snr < 1 )
      aLine(n) = NaN;
    end
  end

  % plot
  hon = ishold;
  hold on;
  plot(fLine, 10 * aLine, mark);
  if( ~hon )
    hold off
  end
