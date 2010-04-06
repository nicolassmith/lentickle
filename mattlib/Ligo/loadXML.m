% Uses xmlconv to convert an XML file to a binary file,
% which it loads and returns.  The XML objects converted
% are named "Result[n]".
%
% [x, y] = loadXML(fileName, n)

function [x, y] = loadXML(fileName, datN)

  if( isempty(datN) )
    x = [];
    y = [];
    return
  end
  
  % convert first data object
  dat = convdat(fileName, 1, datN(1));
  x = zeros(length(dat) / 2, 1);
  y = zeros(length(dat) / 2, length(datN));
  x(:, 1) = dat(1:2:end);
  y(:, 1) = dat(2:2:end);

  % convert remaining data objects
  for n = 2:length(datN)
    y(:, n)  = convdat(fileName, 0, datN(n));
  end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% convdat
function dat = convdat(fileName, XandY, n)

  % set conversion arguments
  conv = 'xmlconv -bf';
  if( ~XandY )
    conv = [conv 'y'];
  end
  tmpFile = '/tmp/tmp.dat';

  % convert XML to binary tmp file
  datName = ['"Result[' int2str(n) ']"'];
  [stat, str] = unix([conv ' ' fileName ' ' tmpFile ' ' datName]);
  if( stat ~= 0 )
    error(sprintf('Unable to convert "%s" in "%s".', datName, fileName));
  else
    disp(sprintf('Got %s from "%s".', datName, fileName));
  end

  % read and delete tmp file
  fid = fopen(tmpFile, 'r');
  dat = fread(fid, inf, 'float');
  fclose(fid);
  delete(tmpFile);
  
