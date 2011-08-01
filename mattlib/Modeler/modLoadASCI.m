% [dat, lgnd] = modLoadASCI(fileName, <scale>)
%
% Inputs:
% fileName 	1xL	the base name of the data file (i.e. without the
%			".dat" extension).
% scale         1x1     scale all inputs by this number (optional)
%
% Outputs:
% dat		NxM	the data
% lgnd		N cell	the name of each data column
%

function [dat, lgnd] = modLoadASCI(fileName, varargin)

  if( length(varargin) > 0 )
    scale = varargin{1};
  else
    scale = 1;
  end

  dat = load([fileName, '.dat']);
  dat(:, 2:2:end) = dat(:, 2:2:end) * scale;

  fid = fopen([fileName, '.dhr']);
  lgnd = {};
  str = fgetl(fid);
  while( isstr(str) )
    lgnd = {lgnd{:}, str};
    str = fgetl(fid);

    n = findstr('.', str);
    if( length(n) > 0 )
      str = str(n(1) + 1:end);
    end
  end
