% A filter from TAMA
%
% [h, hb, h0, h1, h2, h3] = tamaFilt(f)

function [h, h0, h1, h2, h3] = tamaFilt(f)

% make models
[pb0, h0] = tamaFilt0(f);
[pb0, h1] = tamaFilt1(f);
[pb0, h2] = tamaFilt2(f);
[pb0, h3] = tamaFilt3(f);

% make output
h = -h0 .* h1 .* h2 .* h3;
zplotlog(f, [h h0 -h1 -h2 -h3])