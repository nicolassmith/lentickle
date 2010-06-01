function parOut = setPower(parIn,Pinput)
% returns a paramater structure for optEligo, adjusts the input carrier
% power to the desired value (in Watts).
%
% usage: par = setPower(par,20)
% 
% (example for 20W input power)

% find carrier index
vFrf = parIn.Laser.vFrf;
nCarrier = find(vFrf == 0, 1);

% set carrier amplitude
vArf = zeros(size(vFrf));
vArf(nCarrier) = sqrt(Pinput);

% transfer parameters to output variable
parOut = parIn;

% set the power in the output parameter variable
parOut.Pin = Pinput;
parOut.Laser.vArf = vArf;
parOut.Laser.Power = Pinput;
end