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
par = paramPowerL1(35, 12e-12);
par = paramEligo_01_L1(par); %uses param_null for the estimate function
opt = optEligo(par);
opt = probeSens(opt, par);

lentickle = lentickleEligo(opt);

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints);

results = lentickleEngine(lentickle,[],f);

darmol = squeeze(results.errOL(1,1,:));
michol = squeeze(results.errOL(2,2,:));
prcol = squeeze(results.errOL(3,3,:));
carmol = squeeze(results.errOL(4,4,:));