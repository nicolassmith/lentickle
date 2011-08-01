%
% index = getModeIndex(m, n)
%

function index = getModeIndex(m, n)

  mn = m + n;
  index = mn * (mn + 3) / 2 - m;
