%
% [zz, pz, kz] = getZPKz(mf, fs)
%
% get Z-domain zeros and poles for mf

function [zz, pz, kz] = getZPKz(mf, fs, varargin)

  [zs, ps, ks] = getZPKs(mf);
  
  if isempty(varargin)
    % prewarp at each zero/pole
    [zz, pz, kz] = mybilinear(zs, ps, ks, fs);
  else
    % prewarp at given frequency
    [zz, pz, kz] = bilinear(zs, ps, ks, fs, varargin{:});
    if( abs(imag(kz) / real(kz)) > 1e-10 )
      error('Imaginary gain factor.');
    end
    kz = real(kz);
  end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [zz, pz, kz] = mybilinear(zs, ps, ks, fs)

  % transform zeros and poles
  ws = -2 * pi * fs;
  zz = ztransform(zs / ws);
  pz = ztransform(ps / ws);

  % add extra zeros at -1
  zz = [zz; -ones(length(pz) - length(zz), 1)];  

  % compute gain at a few frequencies
  wsg = 2 * pi * fs .* logspace(-9, -1, 10);
  wzg = exp(wsg / fs);

  for n = 1:length(wsg)
    ks0(n) = abs(prod(wsg(n) - zs) ./ prod(wsg(n) - ps));
    kz0(n) = abs(prod(wzg(n) - zz) ./ prod(wzg(n) - pz));
  end
  
  kz = ks * ks0 ./ kz0;
  kz = median(kz);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rz = ztransform(rs)
  FREQ_MAX_WARP = 0.4;
  FREQ_MIN_WARP = 1e-9;

  %%%% frequency prewarping %%%%
  fWarp = abs(rs);

  % limit warp range
  fWarp = min(fWarp, FREQ_MAX_WARP);
  fWarp = max(fWarp, FREQ_MIN_WARP);
  
  % warped radial frequency
  rw = rs .* tan(-pi * fWarp) ./ fWarp;
  
  %%%% transform %%%%
  rz = (1 + rw) ./ (1 - rw);
