%
% [zMax, xMax, yMax] = peak2D(x, y, z, x0, y0, dx, dy)
% find maximum z within dx of x0 and dy of y0
%

function [zMax, xMax, yMax] = peak2D(x, y, z, x0, y0, dx, dy)

  xnFit = find(x < x0 + dx/2 & x > x0 - dx/2);
  ynFit = find(y < y0 + dy/2 & y > y0 - dy/2);

  % find approximate peak location
  [mz, ny] = max(z(ynFit, xnFit));
  [mz, nx] = max(mz);
  ny = ynFit(ny(nx));
  nx = xnFit(nx);

  [zMaxX, xMax] = peak(x(:), z(ny, :)', x0, dx);
  [zMaxY, yMax] = peak(y(:), z(:, nx), y0, dy);

  zMax = (zMaxX + zMaxY) / 2;
