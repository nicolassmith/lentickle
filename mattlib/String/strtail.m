% n = strtail(strA, strB, varargin)
%
% like strhead, but matches reversed strings

function n = strtail(strA, strB, varargin)

  % check arguments
  if ~iscell(strA)
    strA = {strA};
  end
  
  if ~iscell(strB)
    strB = {strB};
  end
  
  % reverse strings in strB
  for m = 1:length(strB)
    str = strB{m};
    strB{m} = str(end:-1:1);
  end
  
  % match strings
  n = [];
  for m = 1:length(strA)
    str = strA{m};
    nn = strmatch(str(end:-1:1), strB, varargin{:});
    n = [n(:); nn(:)];
  end
