function fieldViewer(f)

  % x, y for viewing
  x = -2:0.05:2;
  y = x;

  % x, y for peak finding
  xp = -0.2:0.01:0.2;
  yp = xp;

  for n = 1:size(f, 1)
    % compute intensity data
    I = fieldInten(f(n, :), x, y);

    % find high resolution maximum
    [mz, mx, my] = peak2D(x, y, I, 0, 0, 2, 2);
    zp = fieldInten(f(n, :), xp + mx, yp + my);
    [mz, mx, my] = peak2D(xp + mx, yp + my, zp, mx, my, 2, 2);
    zp = fieldInten(f(n, :), xp/10 + mx, yp/10 + my);
    [mz, mx, my] = peak2D(xp/10 + mx, yp/10 + my, zp, mx, my, 2, 2);

    % draw surface
    surf(x, y, I)

    % cross at zero
    lineZ = 1.01 * mz * ones(2, 2);
    lineX = [-0.1, 0.0; 0.1, 0.0];
    lineY = [0.0, -0.1; 0.0, 0.1];
    line(lineX, lineY, lineZ);

    % cross at max
    a = axis;
    lineX = [a(1), mx; a(2), mx];
    lineY = [my, a(3); my, a(4)];
    line(lineX, lineY, lineZ);

    % make labels
    wx = f(n).x.w0 * sqrt(1 + (f(n).x.z / f(n).x.z0).^2) * 1e6;
    wy = f(n).y.w0 * sqrt(1 + (f(n).y.z / f(n).y.z0).^2) * 1e6;
    title(sprintf('max E^2 = %.3f', mz));
    xlabel(sprintf('max at x = %.1f um (%.2f mw)', mx * wx, mx * 1000));
    ylabel(sprintf('max at y = %.1f um (%.2f mw)', my * wy, my * 1000));

    % set view and shading
    view(2)
    axis square
    shading interp
    colormap((0:255)' * [1, 1, 1] ./ 256);
    drawnow
  end
