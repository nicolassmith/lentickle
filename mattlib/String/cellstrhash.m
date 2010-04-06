% returns a hash code for a cell array of strings
%
% vals = cellstrhash(strs)

function vals = cellstrhash(strs)

  vals = zeros(size(strs));
  for j = 1:prod(size(strs))
    vals(j) = strhash(strs{j});
  end
