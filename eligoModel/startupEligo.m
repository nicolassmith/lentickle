addpath(genpath('../Optickle'));
addpath(genpath('eLIGOcfg'));
addpath(genpath('lib_060504b'));
addpath(genpath('pickleCode'));
%Open used files

% edit DARMcouplBudget12DATA.m
% edit shotPropDATA.m
% edit pickleEligo.m
% edit paramEligo.m
% edit paramPower.m
% edit WFS1.m
% edit analGouyAllCOOL.m

% Configure eLIGO

par = paramPowerL1(35, 12e-12);
par = paramEligo_01_L1(par); %uses param_null for the estimate function
opt = optEligo(par);
%opt = probesEligo_01(opt, par); A and B 90dg apart
opt = probeSens(opt, par);

setupEligo;
pickle = pickleEligo(opt);

% Frequency space

nP = 1000;
Ndof = pickle.param.Ndof;
Nmirr = pickle.param.Nmirr;

f = logspace(-1, 2.5, nP);

%TO BE DONE EVERY TIME THERE IS A CHANGE IN THE PLANT
[fDC, sigDC] = tickle(opt, [], []);

fprintf('REFL A and B power is %g and %g\n', sigDC(nREFLA_DC), sigDC(nREFLB_DC))
fprintf('POX A and B power is %g and %g\n', sigDC(nPOXA_DC), sigDC(nPOXB_DC))
fprintf('AS A and B power is %g and %g\n', sigDC(nASA_DC), sigDC(nASB_DC))
%fprintf('OMCtr A and B power is %g and %g\n', sigDC(nOMCtA_DC), sigDC(nOMCtB_DC))
%fprintf('OMCref A and B power is %g and %g\n', sigDC(nOMCrA_DC), sigDC(nOMCrB_DC))
%fprintf('TRX A and B power is %g and %g\n', sigDC(nTRXA_DC),sigDC(nTRXB_DC))
%fprintf('TRY A and B power is %g and %g\n', sigDC(nTRYA_DC), sigDC(nTRYB_DC))

%save DATA/tickle_LASTnewConfig fDC sigDC
% Load old data instead of running tickle01

[sigAC, mMech] = tickle01(opt, [], f);
%save DATA/tickle01_LASTnewConfig sigAC mMech



% Useful constant values

hP = opt.h; % Planck's constant
e_charge = 1.60217646e-19;  % Coulombs
c_light = opt.c;
l_lambda = opt.lambda;
v_light = c_light / l_lambda;
