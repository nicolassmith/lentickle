% call tdsavg to get average values for data channels
%
% arguments are averaging time (in seconds) and channel names
%
% Example:
% vals = tdsavg(10, 'H1:LSC-NPTRX_OUT16', 'H1:LSC-NPTRY_OUT16');
 
function vals = tdsavg(dt, rcrd, varargin)

  % command for running tdsavg
  cmd = '/cvs/cds/project/tds/bin/tdsavg';

  % make args into cell array
  if( iscell(rcrd) )
    rcrd = {rcrd{:}, varargin{:}};
  else
    rcrd = {rcrd, varargin{:}};
  end  
  
  % build command line
  N = length(rcrd);
  cmd = [cmd ' ' num2str(dt)];
  for n = 1:N
    cmd = [cmd ' ' rcrd{n}];
  end
  
  % execute and parse result
  [r, str] = system(cmd);
  if( r ~= 0 )
    error(['tdsavg failed to run: ' str]);
  end
  vals = str2num(str);
