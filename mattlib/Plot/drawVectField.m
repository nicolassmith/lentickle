% draws a vector field with lines
%
% Arguments:
% x     = x values
% vx    = matrix of x components
% y     = y values
% vy    = matrix of y components
%
% Return:
% None

function DrawVectField(x, vx, y, vy)

N = size(x, 1);
M = size(x, 2);

lx = zeros(2, 2 * M * N);
ly = zeros(2, 2 * M * N);

for n = 1:N
  for m = 1:M
    lx(:, 2*(m + M*n) + 1) = [x(n, m) - vx(n, m) / 2; x(n, m) + vx(n, m) / 2];
    ly(:, 2*(m + M*n) + 1) = [y(n, m) - vy(n, m) / 2; y(n, m) + vy(n, m) / 2];
    
    lx(:, 2*(m + M*n) + 2) = [x(n, m) + vy(n, m) / 4; x(n, m) + vx(n, m) / 2];
    ly(:, 2*(m + M*n) + 2) = [y(n, m) + vx(n, m) / 4; y(n, m) + vy(n, m) / 2];
    
  end
end

if ~ishold
  clf
end

lhand = line(lx, ly);


