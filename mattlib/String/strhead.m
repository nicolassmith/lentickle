% n = strhead(strA, strB, varargin)
%
% matches all strings in strA with strings in strB
% using strmatch
%
% for m = 1:length(strA)
%   nn = strmatch(strA{m}, strB, varargin{:});
%   n = [n(:); nn(:)];
% end

function n = strhead(strA, strB, varargin)

  % check arguments
  if ~iscell(strA)
    strA = {strA};
  end
  
  if ~iscell(strB)
    strB = {strB};
  end
  
  % match strings
  n = [];
  for m = 1:length(strA)
    nn = strmatch(strA{m}, strB, varargin{:});   
    n = [n(:); nn(:)];
  end
