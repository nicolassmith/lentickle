% isMatch = strcmpRE(strings, pattern)
%   returns true if pattern is matched in strings

function isMatch = strcmpRE(strings, pattern)

  reMatch = regexp(strings, pattern);
  
  if ~iscell(strings)
    isMatch = ~isempty(reMatch);
  else
    N = numel(strings);
    isMatch = false(size(strings));
    for n = 1:N
      isMatch(n) = ~isempty(reMatch{n});
    end
  end
  