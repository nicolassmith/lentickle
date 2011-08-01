% call tdswrite to get EPICS values
%
% arguments are record name and value or
%  a cell array of record names and a vector of values
%
% Examples:
% tdswrite('H1:LSC-MICH_GAIN', 5);
% tdswrite({'H1:LSC-MICH_GAIN', 'H1:LSC-PRC_GAIN'}, [-5, -2]);
 
function tdswrite(rcrd, val)

  % command for running tdswrite
  cmd = '/cvs/cds/project/tds/bin/tdswrite';

  % make args into cell array
  if( ~iscell(rcrd) )
    rcrd = {rcrd};
  end  

  N = length(rcrd);
  if( N ~= length(val) )
    error('Number of channels not equal to number of values')
  end
  
  % build command line
  for n = 1:N
    cmd = [cmd ' ' rcrd{n} ' ' num2str(val(n))];
  end
  
  % execute and parse result
  [r, str] = system(cmd);
  if( r ~= 0 )
    error(['tdswrite failed to run: ' str]);
  end
