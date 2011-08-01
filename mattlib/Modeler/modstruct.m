%
%
%

function s = modstruct(name, unit, expr, args, varargin)


  s = struct('name', [], 'unit', 1, 'expr', 1, 'col', [], 'args', []);
  s.name = name;
  s.unit = unit;
  s.expr = expr;

  % data channel
  if( length(varargin) == 1 )
    s.col = varargin{1};
  elseif( length(varargin) == 2 )
    s.col = strmatch(varargin{1}, varargin{2:end});
    if( isempty(s.col) )
      warning(['Unable to find channel "' varargin{1} '"'])
    end
  else
    s.col = [];
  end

  % plot args
  if( iscell(args) )
    s.args = args;
  else
    s.args = {args};
  end

