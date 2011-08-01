% 
% modPlot(dat, spec, varargin)
%
% spec is a cell array of structure arrays
%   spec = {a, b; c [d, e]} will use suplot(2, 2, n) to make 4
%   plots, the last of which will contain two sets of data (d and e)
%
% the structures have the following fields
%   name  = name of the data
%   col   = column to be used in dat
%   unit  = units
%   args  = cell array of plot arguments
%   expr  = optional expression

function modPlot(dat, spec, varargin)

  % set time range
  t = dat(:, 1);
  if( length(varargin) > 0 )
    tRange = varargin{1};
    if( length(tRange) < 2 )
      index = find(t > tRange);
    else
      index = find(t > tRange(1) & t < tRange(2));
    end
    dat = dat(index, :);
    t = dat(:, 1);
    varargin = varargin(2:end);
  end

  % set suplot specs
  if( ~iscell(spec) )
    spec = shiftdim({spec}, -1);
  end
  N = size(spec, 1);
  M = size(spec, 2);

  % plot
  clf
  for n = 1:N
    for m = 1:M
      lgnd = {};
      subplot(N, M, (n - 1) * M + m);
      hold on
      for k = 1:length([spec{n,m}])
        sp = spec{n,m}(k);

	% if there is data to plot
        if( ~isempty(sp.col) )
	  % check for an expression
          if( isfield(sp, 'expr') )
            if( isstr(sp.expr) )
              expr = strrep(sp.expr, '{', 'dat(:, sp.col(');
              expr = strrep(expr, '}', '))');
              d = eval(expr);
            else
              d = dat(:, sp.col) * sp.expr;
            end
	  else
            d = dat(:, sp.col);
          end
          plot(t, d, sp.args{:});
          lgnd = {lgnd{:}, [escformat(sp.name) ' (' sp.unit ')']};
        end
      end
      legend(lgnd, 2);
      grid on
      hold off
    end
  end

