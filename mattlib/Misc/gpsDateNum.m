% Converts LIGO GPS time to a matlab date number
% n = gpsDateNum(gpsTime)
%
% The output date number is NOT local time.
% For PST subtract 8 hours (7 during the summer).
% For EST subtract 5 hours.
%
% (this was done by hand, so it may be a few seconds off)
%

function n = gpsDateNum(gpsTime)

  n = 723186 + (gpsTime - 3648) / (3600 * 24);
