% computes the weighted mean, variance and standard deviation of the mean
%
% [m, v, s] = wmean(x, w);
% 
% Arguments:
% x = data
% w = weights
%
% Returns:
% m = weighted mean = sum(x .* w) / sum(w)
% v = variance = sum(((x - m).^2) .* w) / sum(w)
% s = standard deviation of the mean = sqrt(v / sum(w))
%
% Note:
% the standard deviation of the mean will be correct only if the
% weights are given by w(i) = 1/var(x(i))
%
% If the weights are all 1, the variance is better characterized by
% multiplying the above expression by sum(w)/(sum(w) - 1).
%

function [m, v, s] = wmean(x, w);

wsum  = sum(w);
wxsum = sum(x .* w);
wxsqr = sum( (x .^2) .* w );

m = wxsum/wsum;
v = wxsqr/wsum - m^2;
s = sqrt(v / wsum);
