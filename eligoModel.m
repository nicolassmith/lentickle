% creates eLIGO lentickle model

% frequency domain
f_numpoints = 1000;
f_upperLimit = 7000;
f_lowerLimit = 10;

%darmsens = 'omc'; %use omc

% set up path
addpath(genpath('~/ligo/sim/Optickle'));
addpath(genpath('eligoModel'));
addpath(genpath('mattlib'));
addpath(genpath('pickleCode'));

% set up eLIGO optickle model
par = paramPowerL1(8, 15e-12);
par = paramEligo_01_L1(par); %uses param_null for the estimate function
opt = optEligo(par);
opt = probeSens(opt, par);

% get loop calculations
lentickle = lentickleEligo(opt,darmsens);

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints);
f = f.';

f = [f;30000];

use_saved = 1;

if use_saved
    load('ticklesaved.mat') 
else
    [fDC,sigDC,sigAC, mMech] = tickle(lentickle.opt, [], f); 
    save('ticklesaved.mat','fDC','sigDC','sigAC','mMech')
end

results = lentickleEngine(lentickle,[],f,sigAC,mMech);


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

% darmol = squeeze(results.errOL(1,1,:));
% michol = squeeze(results.errOL(2,2,:));
% prcol = squeeze(results.errOL(3,3,:));
% carmol = squeeze(results.errOL(4,4,:));
% 
% % find relative calibration of AS_Q and OMC_PD
% 
% darm2omc = pickleTF(results,'darm_ctrl','OMC_PD');%,'cl');
% darm2asq = pickleTF(results,'darm_ctrl','AS_Q');%,'cl');
% 
% figure(4)
% SRSbode([f,darm2omc],[f,darm2asq])
% legend('darm\_ctrl to omc','darm\_ctrl to asq')
% 
% omcperasq = mean(darm2omc./darm2asq);
% 
% % get AM coupling
% am2dc = pickleTF(results,'AM','OMC_PD','cl')./omcperasq;
% am2rf = pickleTF(results,'AM','AS_Q','cl');
% 
% figure(2)
% SRSbode([f,am2dc],[f,am2rf])
% legend('DC AM coupling','RF AM coupling')
% 
% % get PM coupling
% am2dc = pickleTF(results,'PM','OMC_PD','cl')./omcperasq;
% am2rf = pickleTF(results,'PM','AS_Q','cl');
% 
% figure(3)
% SRSbode([f,am2dc],[f,am2rf])
% legend('DC PM coupling','RF PM coupling')
% 
% figure(1)
% SRSbode([f,carmol],[f,darmol],[f,prcol],[f,michol])
% legend('cm olg','darm olg','prc olg','mich olg')
