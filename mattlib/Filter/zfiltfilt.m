% y = zfiltfilt(mf, x, fs)
% 
% forward and reverse filters x (with sample frequency fs)
% to produce y (see "filtfilt")
%
% mf is a filter struct, see "filtZPK"

function y = zfiltfilt(mf, x, fs, varargin);

  sos = getSOS(mf, fs, varargin{:});
  y = x;
  for n = 1:size(sos, 1)
    y = filtfilt(sos(n, 1:3), sos(n, 4:6), y);
  end
