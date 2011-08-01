% returns true if IFO is locked
%
% rslt = islocked('H1');

function rslt = islocked(ifoName)

  val = tdsread([ifoName ':LSC-LA_State_Bits_Read']);
  rslt = bitand(val, 32) == 32;
