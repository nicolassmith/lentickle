%
% P(x) for a gaussian distribution.
% p = gaussian(x, mu, sigma)
%

function p = gaussian(x, mu, sigma)

p = exp(-((x - mu) ./ sigma).^2 / 2) ./ (sigma * sqrt(2 * pi));