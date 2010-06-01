% par = paramEligo(version);
% by LisaBar, 15Apr2008
% Returns a parameter set for eLIGO (based on Valera's model)

function par = paramEligo(par)

% basic constants
lambda = 1064e-9;
c = 299792458;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector Geometry (distances in meters)

% Lenghts
lPRC  = 9.182775;  % PRCL: lPRC = lPR + (lIX + lIY) / 2   
lasy  = 0.355;    % Schnupp Asy: lasy = lIX - lIY
lmean = 4.38;  % (lIX + lIY) / 2

par.Length.IX = lmean + lasy / 2; %	lIX = 4.4675, distance [m] from BS to IX
par.Length.IY = lmean - lasy / 2; % lIY = 4.2925, distance [m] from BS to IY
par.Length.EX = 3994.75;  % length [m] of the X arm
par.Length.EY = 3994.75;  % length [m] of the Y arm
par.Length.PR = lPRC - lmean; % distance from PR to BS

% Radius of Curvature [1/m] 
par.IX.ROC = 14600;
par.IY.ROC = 14600;
par.EX.ROC = 7400;
par.EY.ROC = 7400;
par.BS.ROC = Inf;
par.PR.ROC = 14500/1.45;


% Microscopic length offsets
dETM = 0;   % DARM offset, for DC readout TO BE TUNED
par.IX.pos = 0;
par.IY.pos = 0;
par.EX.pos =  dETM;
par.EY.pos = -dETM;
par.BS.pos = 0;
par.PR.pos = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mirror Parameters

% Arm cavity Finesse and imbalance
Ltm = 55e-6;
dLoss = 15e-6;         % determines the contrast defect
% Ltm = 0;
% dLoss = 0;

par.IX.T = 0.028;
par.IY.T = 0.028;

par.BS.T = 0.5;

par.EX.T = 10e-6;
par.EY.T = 10e-6;

% Recycling Mirror Transmissions

par.PR.T = 0.027;


%%%%  PRM configuration %%%%

% par.EX.T = 1;
% par.EY.T = 1;
% par.SR.T = 1;


par.IX.Rar = 500e-6;
par.IY.Rar = 400e-6;
par.EX.Rar = 100e-6;
par.EY.Rar = 100e-6;
par.BS.Rar = 100e-6;
par.PR.Rar = 100e-6;
par.SR.Rar = 100e-6;

par.IX.L = Ltm;
par.IY.L = Ltm;
par.EX.L = Ltm + dLoss;
par.EY.L = Ltm - dLoss;
par.BS.L = 100e-6;
par.PR.L = 100e-6;

% mechanical parameters
par.w = 2 * pi * 0.74; % resonance frequency mirror (rad/s)
par.mass  = 10;		   % mass mirror (kg)

par.w_pit = 2 * pi * 0.5;   % pitch mode resonance frequency

% To be checked parameters for eLIGO
par.rTM = 0.25/2;           % test-mass radius
par.tTM = 0.1;              % test-mass thickness
par.iTM = (3 * par.rTM^2 + par.tTM^2) / 12;  % TM moment / mass

par.iI = par.mass * par.iTM;  % moment of mirrors
          


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Beam Parameters
par.Pin = 35;		% input power (W)
f1 =  24485446;  % first modulation frequency
f2 = 5/2*f1;    % second modulation frequency
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
par.Mod.g1 = 0.3; %  first modulation depth; effectively g = 0.15 if no MZ
par.Mod.g2 = 0.1; % second modulation depth; effectively g = 0.05 if no MZ

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
