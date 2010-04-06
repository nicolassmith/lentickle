%
% s = getFilterString(mf, filterName)
%
% returns a representing mf in E2E FUNC format
%

function s = getFilterString(mf, filterName)

  [z, p, k] = getZPKs(mf);

  s = [filterName, '(x) = digital_filter(', sprintf('%g,\n', k)];

  s = [s sprintf('{ /* zeros */  \n')];
  for n = 1:length(z)
    if( isreal(z(n)) )
      s = [s, sprintf('%g,\n', z(n))];
    end
  end
  s = [s(1:end-2) sprintf('},\n')];

  s = [s sprintf('{ /* poles */  \n')];
  for n = 1:length(p)
    if( isreal(p(n)) )
      s = [s, sprintf('%g,\n', p(n))];
    end
  end
  s = [s(1:end-2) sprintf('},\n')];

  s = [s sprintf('{ /* zero pairs */  \n')];
  for n = 1:length(z)
    if( imag(z(n)) > 0 )
      s = [s, sprintf('(%g, %g),\n', real(z(n)), imag(z(n)))];
    end
  end
  s = [s(1:end-2) sprintf('},\n')];

  s = [s sprintf('{ /* pole pairs */  \n')];
  for n = 1:length(p)
    if( imag(p(n)) > 0 )
      s = [s, sprintf('(%g, %g),\n', real(p(n)), imag(p(n)))];
    end
  end
  s = [s(1:end-2) sprintf('});\n')];
