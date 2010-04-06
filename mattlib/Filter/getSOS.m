%
% sos = getSOS(mf, fs, varargin)
%
% returns mf in second-order-sections for use in real-time filtering
%

function sos = getSOS(mf, fs, varargin)

  [zz, pz, kz] = getZPKz(mf, fs, varargin{:});
  sos = zp2sos(zz, pz, kz);
