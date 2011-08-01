% [dat, lgnd] = modLoad(fileName [, prevdat])
%
% Inputs:
% fileName 	1xL	the base name of the data file (i.e. without the
%			".dat" extension).
% prevdat       Nxm     optional argument, previously read data
%
% Outputs:
% dat		NxM	the data
% lgnd		N cell	the name of each data column
%

function [dat, lgnd] = modLoad(fileName, varargin)

  [dat, lgnd] = e2ebin(fileName, varargin{:});

  % remove root box name
  for n = 1:length(lgnd)
    index = findstr('.', lgnd{n});
    if( length(index) > 0 )
      lgnd{n} = lgnd{n}(index(1) + 1:end);
    end
  end


