% call tdsread to get EPICS values
%
% arguments are strings (first arg may be a cell array of strings)
%
% Example:
% vals = tdsread('H1:LSC-NPTRX_OUT16', 'H1:LSC-NPTRY_OUT16');
 
function vals = tdsread(rcrd, varargin)

  % command for running tdsread
  cmdbase = '/cvs/cds/project/tds/bin/tdsread';

  % make args into cell array
  if( iscell(rcrd) )
    rcrd = {rcrd{:}, varargin{:}};
  else
    rcrd = {rcrd, varargin{:}};
  end  
  
  % build command line
  N = length(rcrd);
  cmd = cmdbase;
  for n = 1:N
    cmd = [cmd ' ' rcrd{n}];
  end
  
  % execute and parse result, try a few times
  n = 0;
  r = 0;
  vals = [];
  while( n < 5 & r == 0 & length(vals) ~= N )
    if( n > 0 )
      errstr = sprintf('tdsread output incomplete after %d tries.', n);
      warning(errstr);
    end
    
    [r, str] = system(cmd);
    if( r == 0 )
      vals = str2num(str);
    end
    n = n + 1;
  end
  
  % check for error
  if( r ~= 0 )
    errstr = sprintf('tdsread failed to run.\n%s:\n%s', cmdbase, str);
    error(errstr);
  end

  if( length(vals) ~= N )
    errstr = sprintf('tdsread output incomplete.\n%s:\n%s', cmdbase, str);
    error(errstr);
  end
