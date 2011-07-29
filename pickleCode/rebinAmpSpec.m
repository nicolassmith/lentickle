% sNew = rebinAmpSpec(f, s, fNew)
%   rebin an amplitude spectrum s
%
% The same as rebinSpec, but for amplitude spectrum insetad
% of power spectrum. Take the square of the spectrum before doing the
% rebin, and then take the square root after.



function sNew = rebinAmpSpec(f, s, fNew)

  s = s.^2;
  sNew = sqrt(rebinPowerSpec(f, s, fNew));
  
end
  