% dualPlot(dat, lgnd, c1, c2, {t, {plot args}})
%
% dat  - data returned by modelerLoad or modelerLoadBin
% lgnd - legend returned by modelerLoad or modelerLoadBin
% c1   - columns and scales for top plot
% c2   - columns and scales for bottom plot
% t    - scalar start time or vector [start, stop] time
% the remaining arguments, if any, are passed to plot
%
% The format of c1 and c2 are either, a 1xN vector of column indices to plot
% with automatic relative scaling, or a 2xN matrix of column indices and their
% relative scales.
%

function dualPlot(dat, lgnd, c1, c2, varargin)

if( length(varargin) > 0 )
  tRange = varargin{1};
  if( length(tRange) < 2 )
    index = find(dat(:, 1) > tRange);
  else
    index = find(dat(:, 1) > tRange(1) & dat(:, 1) < tRange(2));
  end
  dat = dat(index, :);
  varargin = varargin(2:end);
end

if( size(c1, 1) == 1 )
  s1 = [];
else
  s1 = c1(2, :);
  c1 = c1(1, :);
end

if( size(c2, 1) == 1 )
  s2 = [];
else
  s2 = c2(2, :);
  c2 = c2(1, :);
end

clf
subplot(2, 1, 1);
modelerPlot(dat(:, 1), dat, lgnd, c1, s1, varargin{:})
grid on

subplot(2, 1, 2);
modelerPlot(dat(:, 1), dat, lgnd, c2, s2, varargin{:})
grid on
