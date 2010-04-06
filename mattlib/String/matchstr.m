%
% rslt = matchstr(str, pat)
%
% str is a string or cell array of strings
% pat is the pattern to match, this pattern may use the boolean operators
%   "&", "|" and "~" as the first element of a cell array of patterns
%
% Examples:
% % lgnd is a cell array of strings
% c = matchstr(lgnd, '*.Sus?TM?.Mech.thetaX');
% c = matchstr(lgnd, '*.Sus*.Controler.FilterPos.In');
% c = matchstr(lgnd, {'&', '*.Filter*.Out', {'~', '*.Filter.TP.Out'}});

function rslt = matchstr(str, pat)

  lStr = length(str);
  lPat = length(pat);

  % check cell array of strings
  if( iscell(str) )
    rslt = [];
    for nStr = 1:lStr
      if( matchstr(str{nStr}, pat) )
        rslt = [rslt, nStr];
      end
    end
    return
  end
    

  % check cell array pattern
  if( iscell(pat) )
    if( lPat == 0 )
      rslt = 0;
      return
    end

    if( pat{1}(1) == '&' )
      for nPat = 2:lPat
        if( ~matchstr(str, pat{nPat}) )
          rslt = 0;
          return
        end
      end
      rslt = 1;
      return
    end
    
    if( pat{1}(1) == '|' )
      for nPat = 2:lPat
        if( matchstr(str, pat{nPat}) )
          rslt = 1;
          return
        end
      end
      rslt = 0;
      return
    end

    if( pat{1}(1) == '~' )
      for nPat = 2:lPat
        if( matchstr(str, pat{nPat}) )
          rslt = 0;
          return
        end
      end
      rslt = 1;
      return
    end

    error('Invalid cell pattern. First cell must be "&", "|", or "~".');
    rslt = 0;
    return
  end
    
  % match
  if( lStr == 0 & lPat == 0 )
    rslt = 1;
    return
  end

  nPat = 0;
  for nStr = 1:lStr
    nPat = nPat + 1;
    if( nPat > lPat )
      rslt = 0;
      return
    end

    if( pat(nPat) == '*' )
      if( nPat == lPat )
        rslt = 1;
        return
      end
      for nStr = nStr:(lStr + 1)
        if( matchstr(str(nStr:end), pat(nPat + 1:end)) )
          rslt = 1;
          return
        end
      end
      rslt = 0;
      return
    end

    if( pat(nPat) ~= '?' & str(nStr) ~= pat(nPat) )
      rslt = 0;
      return
    end
  end

  nPat = nPat + 1;
  for nPat = nPat:lPat
    if( pat(nPat) ~= '*' )
      rslt = 0;
      return
    end
  end
  rslt = 1;

