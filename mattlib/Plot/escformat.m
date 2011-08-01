%
% str = escformat(str)
%
% escape format commands in str (e.g., '_')
%

function str = escformat(str)

  % deal with cell array of strings...
  if( iscell(str) )
    for n = 1:length(str)
      str{n} = escformat(str{n});
    end
    return
  end

  % escape '_' and '^'
  index = sort([findstr('_', str), findstr('^', str)]);

  for m = length(index):-1:1
    if( str(index(m) - 1) ~= '\' )
      str = [str(1:index(m)-1), '\', str(index(m):end)];
    end
  end
