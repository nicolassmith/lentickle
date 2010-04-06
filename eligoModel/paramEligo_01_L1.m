function par = paramEligo_01_L1(par);

% Sensor Parameters
mfilename = 'paramEligo_01_L1';

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


par.phi.AS_A1 =  (2.1991)  * 180/pi; % 10pm
%par.phi.AS_A1 =  (2.1363)  * 180/pi; % 15pm
%par.phi.AS_A1 =  (2.0735)  * 180/pi; % 20pm
%par.phi.AS_A1 =  (2.2305)  * 180/pi; %7pm
par.phi.AS_B1 = (2.8588 - pi/2)* 180/pi; % AS_B 1 Q for D1 
par.phi.REFL_B2 =  2.6075 * 180/pi; % C1 - unsatable
par.phi.REFL_A2 =  2.4504 * 180/pi; % PRM
par.phi.REFL_A31 = 0.031416 * 180/pi; %not tuned
par.phi.POX_A1 =  0.91106  * 180/pi; % PR not included in analGouy
%par.phi.POX_B1 = (1.7593 - pi/2) * 180/pi; POX B1 for D2
par.phi.POX_B1 = ( 1.0996 - pi/2) * 180/pi;


%I/Q optimized phases

par.phi.REFL_B2 =  (2.4819) * 180/pi; % C1 - unsatable
par.phi.POX_A1 =   (1.4508 + pi/2) * 180/pi;  % ok
par.phi.POX_B1 =   (1.4508 + pi/2 ) * 180/pi; % ok
par.phi.AS_A1 =  ( 1.0753)  * 180/pi;         %ok
par.phi.REFL_A2 =   (2.5133) * 180/pi; % PRM   2.5133



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Guoy Phases - TO BE TUNED

par.gouy.REFL_A = 0;
par.gouy.REFL_B = 0;
par.gouy.POX_A = 0;
par.gouy.POX_B = 0;
par.gouy.POY = 0;
par.gouy.AS_A = 0;
par.gouy.AS_B = 0;
par.gouy.OMCt = 0; 
par.gouy.OMCr = 0; 




par.gouy.REFL_B = 0.91106 ;  % C1 - unsatable
par.gouy.POX_A =  2.3562 ; % C2 POX_A 1 
par.gouy.POX_B = 2.3562;
par.gouy.AS_A = 1.5708 ; % 
par.gouy.REFL_A = 2.7646 ; % PRM % 2.7646





