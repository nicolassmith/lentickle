%
% [f, dat] = fieldLoad(fileName, nDat)
% load field data and return in f
% nDat auxilary data channels are returned in dat
%
%  field data struct is
%   x.w0	x wasit size
%   x.z0	x Rayleigh Range
%   x.z		x distance from waist
%   y.w0	y wasit size
%   y.z0	y Rayleigh Range
%   y.z		y distance from waist
%   a		mode amplitude vector (guoy phase removed)
%

function [f, dat] = fieldLoad(fileName, nDat)

% load raw data
rawDat = load(fileName);
N = size(rawDat, 1);

% strip auxiliary data
if( nDat > 0 )
  dat = rawDat(:, end-nDat:end);
else
  dat = [];
end

% build field struct array
fp = struct('w0', [], 'z0', [], 'z', []);
fs = struct('x', fp, 'y', fp, 'a', []);
f = repmat(fs, N, 1);

% process field data
fDat = rawDat(:, 1:end-nDat);


for j = 1:N

  % basis info
  f(j).x.w0 = fDat(j, 1);
  f(j).x.z0 = fDat(j, 2);
  f(j).x.z = fDat(j, 3);

  f(j).y.w0 = fDat(j, 4);
  f(j).y.z0 = fDat(j, 5);
  f(j).y.z = fDat(j, 6);

  % remove guoy phase
  guoyX = -atan(f(j).x.z / f(j).x.z0);
  guoyY = -atan(f(j).y.z / f(j).y.z0);

  % mode amp info
  amp = fDat(j, 7:end);
  f(j).a = zeros(length(amp)/2, 1);
  for index = 1:length(f(j).a)
    [m, n] = getMN(index - 1);
    guoy = guoyX * (m + 0.5) + guoyY * (n + 0.5);
    f(j).a(index) = (amp(2 * index - 1) + i * amp(2 * index)) * exp(i * guoy);
  end

end
