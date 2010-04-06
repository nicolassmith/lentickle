% call tdsdata to get downsampled data
%
% arguments are sampling frequency (in Hz),
%  averaging time (in seconds) and channel names
%
% a matrix of values is returned with channels by column
%  the first column is the time with t = 0 at the start
%
% Example:
% vals = tdsdata(256, 10, 'H1:LSC-NPTRX_OUT', 'H1:LSC-NPTRY_OUT');
% size(vals)
%% ans =
%%        2560           3

function vals = tdsdata(fs, dt, rcrd, varargin)

  % command for running tdsdata
  cmd = '/cvs/cds/project/tds/bin/tdsdata';

  % make args into cell array
  if( iscell(rcrd) )
    rcrd = {rcrd{:}, varargin{:}};
  else
    rcrd = {rcrd, varargin{:}};
  end  
  
  % build command line
  N = length(rcrd);
  cmd = [cmd ' ' num2str(fs) ' ' num2str(dt)];
  for n = 1:N
    cmd = [cmd ' ' rcrd{n}];
  end
  
  % execute and parse result
  [r, str] = system(cmd);
  if( r ~= 0 )
    error(['tdsdata failed to run: ' str]);
  end
  vals = str2num(str);
