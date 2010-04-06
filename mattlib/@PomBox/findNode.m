% Find node index by name.
%
% n = findNode(pb, str)

function n = findNode(pb, str)

  if isnumeric(str)
    % just use number
    n = str;

    % check for validity
    nMax = pb.N - pb.offset;
    nMin = 1 - pb.offset;
    if n < nMin | n > nMax
      error(sprintf('Node number must be between %d and %d.', nMin, nMax));
    end
  elseif isstr(str)
    % match name
    n = strmatch(str, pb.nStrs);
    if isempty(n)
      error(sprintf('No match for node "%s".', str));
    elseif length(n) > 1
      error(sprintf('Multple matches for node "%s".', str));
    end
  else
    error('Invalid node name type.');
  end
  
