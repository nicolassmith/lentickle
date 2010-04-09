% creates eLIGO lentickle model

% frequency domain
f_numpoints = 1000;
f_upperLimit = 50000;
f_lowerLimit = .1;

% set up path
addpath(genpath('~/ligo/sim/Optickle'));
addpath(genpath('eligoModel'));
addpath(genpath('mattlib'));
addpath(genpath('pickleCode'));

% set up eLIGO optickle model
par = paramPowerL1(20, 12e-12);
par = paramEligo_01_L1(par); %uses param_null for the estimate function
opt = optEligo(par);
opt = probeSens(opt, par);

lentickle = lentickleEligo(opt);

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints);
f = f.';

results = lentickleEngine(lentickle,[],f);

darmol = squeeze(results.errOL(1,1,:));
michol = squeeze(results.errOL(2,2,:));
prcol = squeeze(results.errOL(3,3,:));
carmol = squeeze(results.errOL(4,4,:));

% ctrlSens_inloop = pickleTF(results,'ctrl','sens');
% 
% 
% 
% darm2omc = pickleTF(results,'darm_ctrl','OMC_PD');
% mich2poxi = pickleTF(results,'mich_ctrl','POX_I');
% mich2poxq = pickleTF(results,'mich_ctrl','POX_Q');
% prc2poxi = pickleTF(results,'prc_ctrl','POX_I');
% prc2poxq = pickleTF(results,'prc_ctrl','POX_Q');
% mich2refli = pickleTF(results,'mich_ctrl','REFL1_I');
% mich2reflq = pickleTF(results,'mich_ctrl','REFL1_Q');
% 
% cm2refli = pickleTF(results,'cm_ctrl','REFL1_I');
% cm2reflq = pickleTF(results,'cm_ctrl','REFL1_Q');
% 

%% noise coupling

% find relative calibration of AS_Q and OMC_PD

darm2omc = pickleTF(results,'darm_ctrl','OMC_PD');
darm2asq = pickleTF(results,'darm_ctrl','AS_Q');

omcperasq = darm2omc./darm2asq;

% get AM coupling
am2dc = pickleTF(results,'AM','OMC_PD')./omcperasq;
am2rf = pickleTF(results,'AM','AS_Q');

figure(2)
SRSbode([f,am2dc],[f,am2rf])
legend('DC AM coupling','RF AM coupling')

% get PM coupling
am2dc = pickleTF(results,'PM','OMC_PD')./omcperasq;
am2rf = pickleTF(results,'PM','AS_Q');

figure(3)
SRSbode([f,am2dc],[f,am2rf])
legend('DC PM coupling','RF PM coupling')
