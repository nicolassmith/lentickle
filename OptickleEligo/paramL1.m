% Set of optical parameters for Livingston 4km Interferometers
%
% 
% 

function par = paramL1(par)

% basic constants
lambda = 1064e-9;   % Can't we get inherit these somehow?
c = 299792458;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector Geometry (distances in meters)

% Lengths (check these with measured values and then remove this comment)
lPRC  = 9.182775;  % PRCL: lPRC = lPR + (lIX + lIY) / 2   
lasy  = 0.355;    % Schnupp Asy: lasy = lIX - lIY
lmean = 4.38;     % (lIX + lIY) / 2

par.Length.IX = lmean + lasy / 2;  % lIX = 4.4675, distance [m] from BS to IX
par.Length.IY = lmean - lasy / 2;  % lIY = 4.2925, distance [m] from BS to IY
par.Length.EX = 3995.032;          % length [m] of the X arm
par.Length.EY = 3995.001;          % length [m] of the Y arm
par.Length.PR = lPRC - lmean;      % distance from PR to BS

% Radius of Curvature [1/m] ??? really 1/m ??
% from http://www.ligo.caltech.edu/~gari/COCAsBuilt.htm
par.IX.ROC = 14.76e3;
par.IY.ROC = 14.52e3;
par.EX.ROC = 8.73e3;
par.EY.ROC = 8.72e3;
par.BS.ROC = -189e3;
par.PR.ROC = 15.78e3;


% Microscopic length offsets
dETM = 0;            % DARM offset, for DC readout - leave this as zero
par.IX.pos = 0;
par.IY.pos = 0;
par.EX.pos = 0;      % Set DARMoffset in your own scripts, not here.
par.EY.pos = 0;
par.BS.pos = 0;
par.PR.pos = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mirror Parameters

% Arm cavity Finesse and imbalance
Ltm = 70e-6;
dLoss = 25e-6;         % determines the contrast defect

% HR Transmissivities 
par.IX.T = 0.02930;    % COC web page has T = 0.0288 for both
par.IY.T = 0.029;
par.BS.T = 0.5;

par.EX.T = 10e-6;
par.EY.T = 10e-6;

par.PR.T = 0.0270;

% AR Surfaces
par.IX.Rar = 800e-6;
par.IY.Rar = 80e-6;
par.EX.Rar = 100e-6;
par.EY.Rar = 100e-6;
par.BS.Rar = 80e-6;
par.PR.Rar = 100e-6;
par.SR.Rar = 100e-6;

% HR Losses
par.IX.L = Ltm;
par.IY.L = Ltm;
par.EX.L = Ltm + dLoss;
par.EY.L = Ltm - dLoss;
par.BS.L = 100e-6;
par.PR.L = 100e-6;

% mechanical parameters
par.w = 2 * pi * 0.75;      % resonance frequency of the mirror (rad/s)
par.mass  = 10.5;		    % mass of the mirror (kg)

par.w_pit = 2 * pi * 0.5;   % pitch mode resonance frequency

% Mirror dimensions
par.rTM = 0.25/2;           % test-mass radius
par.tTM = 0.1;              % test-mass thickness
par.iTM = (3 * par.rTM^2 + par.tTM^2) / 12;  % TM moment / mass

par.iI = par.mass * par.iTM;  % moment of mirrors
          


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Beam Parameters
par.Pin = 12;		% input power (W) - P_laser*T_PMC*T_MC*T_FI
f1 = 24485446;          % first modulation frequency (VF March 2008)
f2 = 5/2*f1;            % second modulation frequency
Nmod1 = 1;		% first modulation order
Nmod2 = 1;		% second modulation order

% construct modulation vectors 
n1 = (-Nmod1:Nmod1)';
n2 = (-Nmod2:Nmod2)';
vFrf = unique([n1 * f1; n2 * f2; f1+f2; f1-f2; -(f1+f2); -f1+f2]);

% input amplitude is just carrier
nCarrier = find(vFrf == 0, 1);
vArf = zeros(size(vFrf));
vArf(nCarrier) = sqrt(par.Pin);

par.Laser.vFrf = vFrf;
par.Laser.vArf = vArf;
par.Laser.Power = par.Pin;
par.Laser.Wavelength = lambda;

par.Mod.f1 = f1;
par.Mod.f2 = f2;
par.Mod.g1 = 0.3; %  first modulation depth (radians)
par.Mod.g2 = 0.1; % second modulation depth (radians)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
