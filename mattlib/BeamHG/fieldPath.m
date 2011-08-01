%
% [xPath, yPath] = fieldPath(f)
%
% xPath = [xSlope, xOffset];
% yPath = [ySlope, yOffset];
%

function [xPath, yPath] = fieldPath(f)

  % x, y for peak finding
  x = -2:0.1:2;
  y = x;

  xp = x/10;
  yp = y/10;

  xpp = xp/10;
  ypp = yp/10;

  xPath = zeros(size(f, 1), 2);
  yPath = zeros(size(f, 1), 2);

  zFar = 10;
  eFar = sqrt(1 + zFar^2);

  for n = 1:size(f, 1)
 
    fTmp = f(n, :);

    % find maximum with z = 0
    fTmp.x.z = 0;
    fTmp.y.z = 0;
    zp = fieldInten(fTmp, x, y);
    [mz, mx, my] = peak2D(x, y, zp, 0, 0, 2, 2);
    zp = fieldInten(fTmp, xp + mx, yp + my);
    [mz, mx, my] = peak2D(xp + mx, yp + my, zp, mx, my, 2, 2);
    zp = fieldInten(fTmp, xpp + mx, ypp + my);
    [z0, x0, y0] = peak2D(xpp + mx, ypp + my, zp, mx, my, 2, 2);

    % find maximum with z = zFar * z0
    fTmp.x.z = zFar * fTmp.x.z0;
    fTmp.y.z = zFar * fTmp.y.z0;
    zp = fieldInten(fTmp, x, y);
    [mz, mx, my] = peak2D(x, y, zp, 0, 0, 2, 2);
    zp = fieldInten(fTmp, xp + mx, yp + my);
    [mz, mx, my] = peak2D(xp + mx, yp + my, zp, mx, my, 2, 2);
    zp = fieldInten(fTmp, xpp + mx, ypp + my);
    [z1, x1, y1] = peak2D(xpp + mx, ypp + my, zp, mx, my, 2, 2);

    % compute slope
    ey = sqrt(1 + zFar^2);
    xPath(n, :) = fTmp.x.w0 * [(eFar * x1 - x0) / fTmp.x.z, x0];
    yPath(n, :) = fTmp.y.w0 * [(eFar * y1 - y0) / fTmp.y.z, y0];

    % display
    if( nargout == 0 )
      fprintf(1, 'max E^2 = %.3g, %.3g\n', z0, z1);
      fprintf(1, 'X slope = %.3g um/m, offset = %.3g um, cross = %f\n', ...
	      xPath(n, 1) * 1e6, xPath(n, 2) * 1e6, -xPath(n, 2)/xPath(n, 1));
      fprintf(1, 'Y slope = %.3g um/m, offset = %.3g um, cross = %f\n', ...
	      yPath(n, 1) * 1e6, yPath(n, 2) * 1e6, -yPath(n, 2)/yPath(n, 1));
    end
  end

  % zero small elements
  %  nzx = find(abs(xPath(n, :)) < 1e-11);
  %  nzy = find(abs(yPath(n, :)) < 1e-11);
  %  xPath(n, nzx) = 0;
  %  yPath(n, nzy) = 0;

