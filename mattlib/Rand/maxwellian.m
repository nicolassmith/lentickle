%
% P(x) for a maxwellian distribution.
% p = maxwellian(x, sigma)
%

function p = maxwellian(x, sigma)

z = (x ./ sigma).^2 / 2;
p = 4 * z .* exp(-z) ./ (sigma * sqrt(2 * pi));