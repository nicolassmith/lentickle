% Formatted Error Message
%
% errfmt(<args for sprintf>)

function errfmt(varargin)

  error(sprintf(varargin{:}));
