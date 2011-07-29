% vNoiseOut = pickleNoise(rslt, nameIn, nameOut, vNoiseIn)
%   transfer noise from input point to readout point (uses getNoiseTransfer)
%
% The input noise power may be frequency dependent (Naf x Nin), or
% frequency independent (Nin x 1).  More generally, vNoiseIn maybe
% three dimentional of size Nin x 1 x 1 or Nin x 1 x Naf.
%  
% nameIn and nameOut can be any of the following strings:
% sens, err, ctrl, corr, mirr

function [vNoiseOut, mTF] = pickleNoise_TEST(rslt, nameIn, nameOut, vNoiseIn)

  % compute matrix product
  mTF = rslt.([nameIn 'CL']);
  if ~strcmp(nameIn, nameOut)
    mTF = getProdTF(pickleTF(rslt, nameIn, nameOut), mTF);
  end
      
  % compute noise
  vNoiseOut = getNoiseTransfer(mTF, vNoiseIn);

end
