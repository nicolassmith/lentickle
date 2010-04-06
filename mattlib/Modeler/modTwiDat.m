% modDat = modTwiDat(dat)
%
%

function modDat = modTwiDat(dat)

modDat = dat;

% make l- = -zRec - sqrt(2) * zBS
modDat(:, :, 3,  :) = -dat(:, :, 6, :) - sqrt(2) * dat(:, :, 5, :);

% make l+ = -zRec
modDat(:, :, 4,  :) = -dat(:, :, 6, :);

% multiply pob signals (here taken from the recycling mirror)
% by the beamsplitter transmission coefficient
modDat(:, 3:4, :,  :) = dat(:, 3:4, :, :) * 0.5;

% rotate demod phases and invert quad-phase
% (different adlib vs. twiddle quad-phase definitions?)
phi = zeros(size(modDat, 2)/2);
phi(1) = 0;			% ref
phi(2) = 0;			% pob (this is actually at the RM)
phi(3) = -1.27312;		% asy
phi(4) = -1.47826;		% pot
phi(5) = -1.66379;		% por

tmpDat = zeros(size(modDat));
for n = 1:(size(modDat, 2)/2)
  tmpDat(:, 2*n - 1, :, :) = cos(phi(n)) * modDat(:, 2*n - 1, :, :) - ...
                             sin(phi(n)) * modDat(:, 2*n, :, :);
  tmpDat(:, 2*n, :, :)    = -sin(phi(n)) * modDat(:, 2*n - 1, :, :) - ...
                             cos(phi(n)) * modDat(:, 2*n, :, :);
end

modDat = tmpDat;
