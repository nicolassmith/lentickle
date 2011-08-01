% A filter from TAMA
%
% [pb, hOut, h, j] = tamaFilt(f)

function [pb, hOut, h, c] = tamaFilt(f)

% make model
pb = PomBox('Vin', '1p', '1m', '1o', '2m', '2o', '3m', '3o', '4m', '4o', 'Ground');

% add resistor
pb = addComp(pb, 'R1', '1o', '1m', 1210);
pb = addComp(pb, 'R2', '3o', '1m', 1780);
pb = addComp(pb, 'R6', '2o', '1p', 332);
pb = addComp(pb, 'R7', 'Vin', '1p', 750);
pb = addComp(pb, 'R8', '1o', '2m', 2610);
pb = addComp(pb, 'R11', '2o', '3m', 127);
pb = addComp(pb, 'R12', '1o', '4m', 7320);
pb = addComp(pb, 'R13', '4o', '4m', 2740);
pb = addComp(pb, 'R15', '3o', '4m', 2076);

% add capacitors
pb = addComp(pb, 'C1', '3o', '3m', 0, 1.7e6);
pb = addComp(pb, 'C2', '2o', '2m', 0, 5.6e6);

% add amplifiers
pb = addAmp(pb, 'amp1', '1p', '1m', '1o');
pb = addAmp(pb, 'amp2', 'Ground', '2m', '2o');
pb = addAmp(pb, 'amp3', 'Ground', '3m', '3o');
pb = addAmp(pb, 'amp4', 'Ground', '4m', '4o');

% make response, if requested
if( nargin > 0 & nargout > 0 )
    [h, c] = solve(pb, f);
    nOut = findNode(pb, '4o');
    hOut = h(:, nOut);
end
