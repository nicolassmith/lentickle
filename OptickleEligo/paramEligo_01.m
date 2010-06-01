function par = paramEligo_01(par)

% Sensor Parameters
mfilename = 'paramEligo_01';

% Demodulation Phases -- TO BE TUNED!

par.phi.REFL_A1 = 0;
par.phi.REFL_A2 = 0; 
par.phi.REFL_A31 = 0;
par.phi.REFL_A32 = 0;
par.phi.REFL_AM = 0;
par.phi.REFL_AP = 0;

par.phi.REFL_B1 = 0;
par.phi.REFL_B2 = 0;
par.phi.REFL_B31 = 0;
par.phi.REFL_B32 = 0;
par.phi.REFL_BM = 0;
par.phi.REFL_BP = 0;

par.phi.POX_A1 = 0;
par.phi.POX_AM = 0;
par.phi.POX_AP = 0;
par.phi.POX_A2 = 0;
par.phi.POX_A21 = 0;
par.phi.POX_A22 = 0;

par.phi.POX_B1 = 0;
par.phi.POX_BM = 0;
par.phi.POX_BP = 0;
par.phi.POX_B2 = 0;
par.phi.POX_B21 = 0;
par.phi.POX_B22 = 0;

par.phi.POY_A1 = 0;
par.phi.POY_AM = 0;
par.phi.POY_AP = 0;
par.phi.POY_A2 = 0;
par.phi.POY_A21 = 0;
par.phi.POY_A22 = 0;

par.phi.POY_B1 = 0;
par.phi.POY_BM = 0;
par.phi.POY_BP = 0;
par.phi.POY_B2 = 0;
par.phi.POY_B21 = 0;
par.phi.POY_B22 = 0;

par.phi.AS_AP = 0;
par.phi.AS_AM = 0;
par.phi.AS_A1 = 0;
par.phi.AS_A2 = 0;
par.phi.AS_A21 = 0;
par.phi.AS_A22 = 0;

par.phi.AS_BP = 0;
par.phi.AS_BM = 0;
par.phi.AS_B1 = 0;
par.phi.AS_B2 = 0;
par.phi.AS_B21 = 0;
par.phi.AS_B22 = 0;

par.phi.OMCr_A1 = 0;
par.phi.OMCr_A2 = 0;
par.phi.OMCr_AM = 0;
par.phi.OMCr_AP = 0;

par.phi.OMCr_B1 = 0;
par.phi.OMCr_B2 = 0;
par.phi.OMCr_BM = 0;
par.phi.OMCr_BP = 0;

par.phi.OMCt_A1 = 0;
par.phi.OMCt_A2 = 0;
par.phi.OMCt_AM = 0;
par.phi.OMCt_AP = 0;

par.phi.OMCt_B1 = 0;
par.phi.OMCt_B2 = 0;
par.phi.OMCt_BM = 0;
par.phi.OMCt_BP = 0;


par.phi.AS_A1 = 2.5761 * 180/pi;
par.phi.REFL_B2 =  2.5133 * 180/pi;
par.phi.POX_A1 = 0.8168 * 180/pi;
par.phi.REFL_A1 = 2.3562 * 180/pi;

% if exist(strcat(mfilename, '_demph.mat'), 'file') > 0
%    display(['Loading ' mfilename, '_demph.mat']);
%    load(strcat(mfilename, '_demph.mat'));  
%    par.phi = phases;
%  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Guoy Phases - TO BE TUNED

par.gouy.REFL = 0;
par.gouy.POX = 0;
par.gouy.POY = 0;
par.gouy.AS = 0;
par.gouy.OMCt = 0; 
par.gouy.OMCr = 0; 

par.gouy.AS = 1.8221;
par.gouy.REFL = 0.4084;
par.gouy.POX = 0.8796;
