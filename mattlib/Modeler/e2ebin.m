%
% e2ebin reads e2e output data
%  An optional second argument is the data previously read from
%  this file.  Adding this argument, if available, will save time.
%
% [dat, titles] = e2ebin( 'filename' )
%
function [dat, titles] = e2ebin(filename, varargin)

  % return values on error
  dat = [];
  titles = {};

  % parse arguments
  if( isempty(varargin) )
    prevdat = [];
  else
    prevdat = varargin{1};
  end

  % open file
  fid = fopen( filename,'r' );
  if fid == -1
    error('File does not exist');
  end;

  % read number of data channels
  [numData, count] = fread(fid, 1, 'int32');
  if numData == 0 | count == 0
    fclose(fid);
    return;
  end;

  % read legend string
  [leng, count] = fread(fid, 1, 'int32');
  fullTitle = fread(fid, leng, 'char')';

  % parse title string
  indTitle = findstr(fullTitle, sprintf('\n'));
  numTitle = length(indTitle);
  if( numTitle ~= numData )
    errStr = 'ERROR in data file.  NumTitle ~= NumData. %d ~= %d';
    errStr = sprintf(errStr, numTitle, numData);
    error(errStr);
  end
  titles = cell(numTitle, 1);
  titles{1} = char(fullTitle(1:indTitle(1) - 1));
  for n = 2:numTitle
    titles{n} = char(fullTitle(indTitle(n - 1) + 1:indTitle(n) - 1));
  end

  % read data
  if( isempty(prevdat) )
    dat = fread(fid, [numData, inf], 'float64')';
  elseif( size(prevdat, 2) ~= numData )
    errStr = 'Previously loaded data does not match current data. %d ~= %d';
    errStr = sprintf(errStr, size(prevdat, 2), numData);
    error(errStr);
  else
    if( fseek(fid, 8 * prod(size(prevdat)), 0) == -1 )
      fprintf(2, 'Previously loaded data longer than current data.\n')
      prevdat = [];
    end
    dat = fread(fid, [numData, inf], 'float64')';
  end    
  fclose(fid);

  dat = [prevdat; dat(1:end - 1, :)];

  return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  strIndex = 1;
  offset = 1;
  charOffset = 0;
  CRchar = sprintf('\n');
  while offset <= leng & strIndex <= numData
    if fullTitle(offset) == CRchar
      titles{strIndex} = sss;
      strIndex = strIndex + 1;
      charOffset = 0;
    else
      if charOffset == 0
        sss = sprintf('%c',fullTitle(offset));
      else
        sss = sprintf('%s%c',sss,fullTitle(offset));
      end
      charOffset = charOffset + 1;
    end
    offset = offset + 1;
  end
  if charOffset ~= 0
    titles{strIndex} = sss;
  end
    
