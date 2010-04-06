% Possion pdf
%
% x     any
% lam   1x1

function p = poisspdf(x, lam)

p = (lam .^ x) * exp(-lam) ./ gamma(x + 1);