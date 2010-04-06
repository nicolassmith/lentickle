% A filter from TAMA
%
% [pb, hOut, h, j] = tamaFilt0(f)

function [pb, hOut, h, c] = tamaFilt0(f)

% make model
pb = PomBox('Vin', '1m', '1o', '1f',  '2i', '2m', '2o', 'Ground');

% add resistors
pb = addComp(pb, 'R20', 'Vin', '1m', 2200);
pb = addComp(pb, 'R22', '1o', '1m', 1e5);
pb = addComp(pb, 'R25', '1f', '1m', 2200);
pb = addComp(pb, 'R26', '1o', '2i', 470);
pb = addComp(pb, 'R115', '1o', '2m', 1000);
pb = addComp(pb, 'R116', '2o', '2m', 6800);

% add capacitors
%pb = addComp(pb, 'C31', '1o', '1f', 0, 44e6); % the boost can be switched
pb = addComp(pb, 'C35', '2i', '2m', 0, 3.3e6);

% add amplifiers
pb = addAmp(pb, 'amp1', 'Ground', '1m', '1o');
pb = addAmp(pb, 'amp2', 'Ground', '2m', '2o');

% make response, if requested
if( nargin > 0 & nargout > 0 )
    [h, c] = solve(pb, f);
    nOut = findNode(pb, '2o');
    hOut = h(:, nOut);
end
