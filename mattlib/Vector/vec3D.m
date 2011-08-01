% return 3-D vector with given z
%
% v3 = vec3D(v, z)

function v3 = vec3D(v, z)

  if nargin == 1
    z = 0;
  end
  
  v3 = zeros(3, size(v, 2));
  v3(1:2, :) = v;
  v3(3, :) = z;
  