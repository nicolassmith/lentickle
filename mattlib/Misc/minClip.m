%
% b = minClip(a, clipVal)
% if( a(n) > clipVal )
%   b(n) == a(n)
% else
%   b(n) = clipVal
% end
%

function b = minClip(a, clipVal)

  b = max(clipVal * ones(size(a)), a);