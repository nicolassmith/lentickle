% vNoiseOut = pickleNoise(rslt, nameFrom, nameTo, vNoiseIn)
%   transfer noise from input point to readout point (uses getNoiseTransfer)
%
% The input noise power may be frequency dependent (Naf x Nin), or
% frequency independent (Nin x 1).  More generally, vNoiseIn maybe
% three dimentional of size Nin x 1 x 1 or Nin x 1 x Naf.
%  
% nameFrom and nameTo can be any of the following strings:
% sens, err, ctrl, corr, mirr

function vNoiseOut = pickleNoise(rslt, nameFrom, nameTo, vNoiseIn)

  % grab closed loop TF
    mTF = pickleTF(rslt, nameFrom, nameTo,'cl');
      
  % compute noise
  vNoiseOut = getNoiseTransfer(mTF, vNoiseIn);

end
