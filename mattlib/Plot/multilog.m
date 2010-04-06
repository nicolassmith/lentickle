% Plot multiple data sets on a log plot.  Data format should be:
% x = dat(:, 1); y = dat(:, 2:end);
%
% multilog(dat0, dat1, ...)

function multilog(dat0, varargin)

  N = length(varargin);
  str = sprintf('dat0(:,1), dat0(:,2:end)', 1, 1);
  for n = 1:N
    str = [str sprintf(', varargin{%d}(:,1), varargin{%d}(:,2:end)', n, n)];
  end
  eval(['loglog(' str ')']);
