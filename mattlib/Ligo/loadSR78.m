% [h, f] = loadSR78(n_dbmag, n_phase)
%
% load ASCII data from files
% dbMag = sprintf('SCRN%0.4d.TXT', n(:, 1));
% phase = sprintf('SCRN%0.4d.TXT', n(:, 2));

function [h, f] = loadSR78(nfile)
  
  N = size(nfile, 1);
  if( N == 0 )
    error('No files specified')
  end
  
  % get first file
  [h1, f1] = loadSR78single(nfile(1, :));

  % init vectors
  M = size(f1, 1);
  f = zeros(M, N);
  h = zeros(M, N);

  h(:, 1) = h1;
  f(:, 1) = f1;

  for n = 2:N
    [h(:, n), f(:, n)] = loadSR78single(nfile(n, :));
  end
  
  return
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h, f] = loadSR78single(nfile)
  dbMag = load(sprintf('SCRN%0.4d.TXT', nfile(1)));
  phase = load(sprintf('SCRN%0.4d.TXT', nfile(2)));

  f = dbMag(:, 1);
  h = 10.^(dbMag(:,2) / 20) .* exp((i * pi / 180) * phase(:,2));
