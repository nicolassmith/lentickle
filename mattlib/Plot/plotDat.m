% plotDat(dat, lgnd, cols, [trange, ...])
%

function plotDat(dat, lgnd, colA, varargin)

  % parse input arguments
  switch nargin
   case 3
    colB = [];
    trange = [];
   case 4
    colB = [];
    trange = varargin{1};
   case 5
    colB = varargin{1};
    trange = varargin{2};
   otherwise
    error('Invalid number of input arguments.')
  end
  
  % decipher trange
  if length(trange) == 1
    n = find(dat(:, 1) > trange(1));
  elseif length(trange) == 2
    n = find(dat(:, 1) > trange(1) & dat(:, 1) < trange(2));
  else
    n = 1:size(dat, 1);
  end

  % plot data
  if isempty(colB)
    plot(dat(n, 1), dat(n, colA))
    legend(lgnd{colA}, 'Location', 'Best');
  else
    subplot(2, 1, 1)
    plot(dat(n, 1), dat(n, colA))
    legend(lgnd{colA});

    subplot(2, 1, 2)
    plot(dat(n, 1), dat(n, colB))
    legend(lgnd{colB});
  end
  
