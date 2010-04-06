%
% b = maxClip(a, clipVal)
% if( a(n) < clipVal )
%   b(n) == a(n)
% else
%   b(n) = clipVal
% end
%

function b = maxClip(a, clipVal)

  b = min(clipVal * ones(size(a)), a);
