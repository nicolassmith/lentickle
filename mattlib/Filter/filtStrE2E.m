% s = filtStrE2E(mf, filterName)
% returns a representing mf in E2E FUNC_X format
%
% (derived from getFilterString)

function s = filtStrE2E(mf, filterName)

  [z, p, k] = getZPKs(mf);

  s = ['// ' filterName '\n'];
  s = [s filterName sprintf('.setGain(%g);\n', k)];
  for n = 1:length(z)
    if( isreal(z(n)) )
      s = [s filterName sprintf('.addZero(%g);\n', z(n))];
    end
  end

  for n = 1:length(p)
    if( isreal(p(n)) )
      s = [s filterName sprintf('.addPole(%g);\n', p(n))];
    end
  end

  for n = 1:length(z)
    if( imag(z(n)) > 0 )
      s = [s filterName sprintf('.addZeroPair(%g, %g);\n', real(z(n)), imag(z(n)))];
    end
  end

  for n = 1:length(p)
    if( imag(p(n)) > 0 )
      s = [s filterName sprintf('.addPolePair(%g, %g);\n', real(p(n)), imag(p(n)))];
    end
  end
