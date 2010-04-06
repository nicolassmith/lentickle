% A filter from TAMA
%
% [pb, hOut, h, j] = tamaFilt1(f)

function [pb, hOut, h, c] = tamaFilt1(f)

% make model
pb = PomBox('Vin', '1p', '1m', '1o', '2m', '2o', '3m', '3o', '4m', '4o', 'Ground');

% add resistors
pb = addComp(pb, 'R3', '1o', '1m', 1370);
pb = addComp(pb, 'R4', '3o', '1m', 1400);
pb = addComp(pb, 'R5', '2o', '1p', 1000);
pb = addComp(pb, 'R9', 'Vin', '1p', 1000);
pb = addComp(pb, 'R10', '1o', '2m', 1000);
pb = addComp(pb, 'R14', '2o', '3m', 1000);
pb = addComp(pb, 'R28', '1o', '4m', 205.2e3);
pb = addComp(pb, 'R29', '4o', '4m', 1150);
pb = addComp(pb, 'R30', '3o', '4m', 1180);

% add capacitors
pb = addComp(pb, 'C16', '3o', '3m', 0, 3.5e6);
pb = addComp(pb, 'C17', '2o', '2m', 0, 7e6);

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
