% A filter from TAMA
%
% [pb, hOut, h, j] = tamaFilt(f)

function [h, hb, h0, h1, h2, h3] = tamaFilt(f)

% make models
[pb0, h0, h00] = tamaFilt0(f);
[pb0, h1] = tamaFilt1(f);
[pb0, h2] = tamaFilt2(f);
[pb0, h3] = tamaFilt3(f);

% find boost stage
n = findNode(pb0, '2o');
hb = h00(:, n);

h = -h0 .* h1 .* h2 .* h3;
zplotlog(f, [h h0 -h1 -h2 -h3])