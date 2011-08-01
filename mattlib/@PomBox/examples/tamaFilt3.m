% A filter from TAMA
%
% [pb, hOut, h, j] = tamaFilt(f)

function [pb, hOut, h, c] = tamaFilt(f)

% make model
pb = PomBox('Vin', '1p', '1m', '1o', '2m', '2o', '3m', '3o', '4m', '4o', 'Ground');

% add resistors
pb = addComp(pb, 'R16', '1o', '1m', 1000);
pb = addComp(pb, 'R17', '3o', '1m', 1000);
pb = addComp(pb, 'R18', '2o', '1p', 274);
pb = addComp(pb, 'R21', 'Vin', '1p', 274);
pb = addComp(pb, 'R23', '1o', '2m', 1862);
pb = addComp(pb, 'R24', '2o', '3m', 61.9);
pb = addComp(pb, 'R27', '1o', '4m', 2050);
pb = addComp(pb, 'R31', '4o', '4m', 1000);
pb = addComp(pb, 'R32', '3o', '4m', 1000);

% add capacitors
pb = addComp(pb, 'C3', '3o', '3m', 0, 1.1e6);
pb = addComp(pb, 'C4', '2o', '2m', 0, 23e6);

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
