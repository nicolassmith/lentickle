%
%
%

function a = isIn(m, varargin)

  try
    a = m(varargin{:});
    a = 1;
  catch
    a = 0;
  end
