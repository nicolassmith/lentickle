function par = paramEligo_00(par)

% Sensor Parameters
mfilename = 'paramEligo_00';

% Demodulation Phases -- tuned with getDemodPhases

par.phi.phREFL1 = -95.6124;% 38.1;
par.phi.phREFL2 = 28.8432;% 38.1;

par.phi.phPOX1 = 51.948;%-19.0;

par.phi.phPOY1 = 0;

par.phi.phAS1 = -55.351; %22.1;
par.phi.phAS2 = 0;

par.phi.phOMCR1 = 0;
par.phi.phOMCR2 = 0;

par.phi.phOMCT1 = 0;
par.phi.phOMCT2 = 0;

% if exist(strcat(mfilename, '_demph.mat'), 'file') > 0
%    display(['Loading ' mfilename, '_demph.mat']);
%    load(strcat(mfilename, '_demph.mat'));  
%    par.phi = phases;
%  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


