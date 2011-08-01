%
% [amp, tDat, sDat] = modResp(dat, [freq = 100, phase = 0, t0 = 0])
%
% dat is Nx2 with t == dat(:,1) and x == dat(:,2)
% freq, phase and t0 describe the reference sin wave:
% sRef = sin( 2 * pi * ((t - t0) * freq - phase / 360) )
%
% amp is the complex amplitude of sRef in x
% tDat and sDat are for ploting the sRef over x
%

function [amp, tDat, sDat] = modResp(dat, varargin)

  % get varargs
  freq = 100;
  phase = 0;
  t0 = 0;

  if( length(varargin) > 0 )
    freq = varargin{1};
  end
  if( length(varargin) > 1 )
    phase = varargin{2};
  end
  if( length(varargin) > 2 )
    t0 = varargin{3};
  end

  % get amplitudes in quadrature
  rAmp = modAmp(dat, freq, phase, t0);
  iAmp = modAmp(dat, freq, phase + 90, t0);

  amp = rAmp + i * iAmp;

  if( nargout > 1 )
    tDat = dat(:,1);
    sDat = abs(amp) * sin(2*pi*((tDat - t0) * freq - phase/360) - angle(amp));
  end
