% transforms a vector from one spherical coordinate system to another
%
% Arguments are (v, trans) where v is [theta, phi, r] and trans is the
% transformation angles [theta, phi, psi]

function vf = sph2sph(vi, trans)

% compute Cartesian coordinates of the vector
vcart = zeros(3, 1);

vcart(1) = cos(vi(1)) * sin(vi(2)) * vi(3);
vcart(2) = sin(vi(1)) * sin(vi(2)) * vi(3);
vcart(3) = cos(vi(2)) * vi(3);

% rotate by theta about original z-axis
rt = ...
  [ cos(trans(1)) -sin(trans(1))  0.0 ; ...
    sin(trans(1))  cos(trans(1))  0.0 ; ...
    0.0            0.0            1.0 ];

vcart = rt * vcart;

% rotate by phi about current y-axis
rt = ...
  [ cos(trans(2))  0.0  sin(trans(2)) ; ...
    0.0            1.0            0.0 ; ...
   -sin(trans(2))  0.0  cos(trans(2)) ];

vcart = rt * vcart;

% rotate by psi about current z-axis
rt = ...
  [ cos(trans(3)) -sin(trans(3))  0.0 ; ...
    sin(trans(3))  cos(trans(3))  0.0 ; ...
    0.0            0.0            1.0 ];

vcart = rt * vcart;

% compute new spherical coordinates
vf = zeros(3, 1);
vf(1) = atan2(vcart(2), vcart(1));
vf(3) = sqrt( vcart(1)^2 + vcart(2)^2 + vcart(3)^2 );
vf(2) = acos(vcart(3)/vf(3));

return;
