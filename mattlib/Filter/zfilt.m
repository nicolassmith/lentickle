% y = zfilt(mf, x, fs)
% 
% filters x (with sample frequency fs) to produce y
% mf is a filter struct, see "filtZPK"

function y = zfilt(mf, x, fs, varargin);

  sos = getSOS(mf, fs, varargin{:});
  y = x;
  for n = 1:size(sos, 1)
    y = filter(sos(n, 1:3), sos(n, 4:6), y);
  end

  % this doesn't seem to work
  %[bz, az] = getBAz(mf, fs);
  %y = filter(bz, az, x);
