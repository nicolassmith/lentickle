% NB is a simplified initial LIGO noise budget made from
%    by replacing the measured noise with some smooth
%    curves which can be more easily scaled.


disp('Setting Parameters...')

%a few constants
h = 6.626e-34;                           % Planck Constant in J s
kB = 1.381e-23;                          % Boltzmann Constant
T = 295;                                 % Room Temperature

%Pendulum parameters
fp = 0.75;
wp = 2*pi*fp;
Qp = 50;

%get the set of parameters from the param file
par = L1IFOparams;
noise_par = L1_NoiseParams;

%extract a few parameters from par
ec = par.misc.ec;
c = par.misc.c;
lambda = par.misc.lambda;
nu = c/lambda;
L = par.darm.armlength;
m_los = par.los.m;

ff = logspace(1,4,301)';


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Auxillary Length Controls
disp('Calculating MICH and PRC...')

mpdata = load('Data/MICHPRC.txt');
mpdata = mpdata(2:end,:);

% 2X increase in detected power
less_shot = 1/sqrt(2);

% BS DC cal is 1.13 nm/ct for L1 (3/24/2005 ilog)
% RM DC cal is 0.45 nm/ct for L1 (good guess)

mich_dc = 2 * 10.5 * 0.45e-9; % Includes output matrix
mich2asq = 1/137;
mich_dcpl = 1/160;
mich = mich_dcpl * mich2asq * mich_dc * less_shot *...
       abs(pendulum(0.75,10,mpdata(:,1))) .* mpdata(:,2);
mich = [mpdata(:,1) mich];

prc_dc = 7.4 * 0.45e-9; % Includes LSC output matrix
prc2asq = 1/1000;
prc_dcpl = 1/30;
prc = prc_dcpl * prc2asq * prc_dc * less_shot *...
      abs(pendulum(0.75,10,mpdata(:,1))) .* mpdata(:,3);
prc = prc .* abs(mybodesys(zpk(-2*pi*85,-2*pi*8500,100),mpdata(:,1)));
prc = [mpdata(:,1) prc];

  
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% -- SEISMIC NOISE ============================================================

% Support tube noise at test mass tanks in meters
disp('Calculating Seismic Noise...')

seism_dc = noise_par.seism_dc;

seism = load('809335596/H1_SEISH-809335596.txt');
seism = seism(2:end,:);
seisv = load('809335596/H1_SEISV-809335596.txt');
seisv = seisv(2:end,:);
tmp = seism_dc ./ seism(:,1).^2;
tt1 = tmp(cumsum(ones(length(tmp),5),1));
tt1(:,1) = 1;
seism = seism .* tt1;
tmp = seism_dc ./ seisv(:,1).^2;
tt2 = tmp(cumsum(ones(length(tmp),5),1));
tt2(:,1) = 1;
seisv = seisv .* tt2;

seismos = SeismicNoise(seism(2:end,:),seisv(2:end,:),'noplot');

% 8 dB of peaking at 9 Hz (DC gain of 1)
rubber = zpk(-2*pi*15,-2*pi*[2+9i;2-9i],1);
[rmag,rphase] = bode(rubber,2*pi*0.01);
rubber = abs(mybodesys(rubber,seismos(:,1))) / rmag;

seis_rub = [seismos(:,1) seismos(:,2) .* rubber];
% ===========================================================================


% - - - - Angular Noise - - - --  - - - - - -- - - - - - - - - - - 
disp('Fudging the Angular control noises...')

% Based on measured contribution in L1
ang_noise = 2e-17 * (32./ff).^12;

% Future filter
[z,p,k] = ellip(2,1,6,2*pi*30,'s');
fm9 = abs(mybodesys(zpk(z,p,k*10^(1/20)),ff));

ang_noise = [ff ang_noise.*fm9];
% - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -- - - - 


%*****************************************************************************
% Output Electronics (DAC, Dewhitening, Coil Driver)
disp('Calculating Output Electronics Noise...')

% FIX  ->  Use measured DAC noise

[etmnoise] = output_electronics(ff',300e-9,'ETM_Z');
[itmnoise] = output_electronics(ff',300e-9,'ITM_Z');
[bsnoise] = output_electronics(ff',10e-6,'BS_Z');
%[rmnoise] = output_electronics(ff',10e-6,'RM');

two_masses = sqrt(2); % Incoherent sum of 2 masses
four_coils = 2;  % Incoherent sum of 4 coils

ptf = abs(pendulum(fp,Qp,ff));

etmnoise = (etmnoise ./ m_los) .* (ptf./wp^2);
etmnoise = etmnoise * noise_par.G_OSEM * four_coils * two_masses;    

itmnoise = (itmnoise ./ m_los) .* (ptf./wp^2);
itmnoise = itmnoise * noise_par.G_OSEM * four_coils * two_masses;    

bsnoise = (bsnoise ./ m_los) .* (ptf./wp^2);  
bsnoise = bsnoise * noise_par.G_OSEM * four_coils * sqrt(2) / 137; % sqrt(2) for angle

% Notes for stupid people:
% gBS = 0.016 * 2 * sqrt(2) / (137 * (2 * pi)^2 * 4.2)
% loglog(ff, bsnoise * gBS ./ ff.^2);


sus_electronics = sqrt(etmnoise.^2 + itmnoise.^2 + bsnoise.^2);

%*****************************************************************************

% Suspension Thermal Noise ------------------------------------------------
disp('Calculating Suspension Thermal Noise...')

% FIX  ->  Calculate 1 curve for each string


[tnetm] = PendThermTE('ETMXparameters_TE',ff,-0.01);       % Gaby's thermal noise,
                                                   % phi = 1e-3 for steel

%tnok = PendTherm('ETMXparameters_hope',ff,-0.0095); % Gaby's thermal noise,
                                                       % phi = 5e-4 for steel
                                                       % beam lowered by 1 cm
%tnetm = tnok;
tnetm = 2 * tnetm';                                 % Factor of 2 from 4 masses
%---------------------------------------------------------------------------



% Internal Mode Thermal Noise - - - - - - - - - - - - - - - - - - - - - - - - -
disp('Calculating Internal Mode Thermal Noise...')

% This includes all 4 masses and differences between ITMs and ETMs
x_int = mirror_thermal(ff);
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% Shot Noise ***************************************************************
disp('Calculating Shot Noise...')
Gamma = 0.25;
J0 = besselj(0,Gamma);
J1 = besselj(1,Gamma);

% L1 in June
Pin = 30;                              % Power into RM
c_d = 5e-6;                           % TEM00 unbalance in L1
tsb = sqrt(0.60);                     % Sideband ampl trans
olap = 0.7;                           % Overlap

% DARM offset for DC readout
dc_darm_offset = 20e-12;

shot0 = shot_noise(ff, Pin, Gamma, c_d, tsb, olap, dc_darm_offset);

Pin = 6;
shot1 = shot_noise(ff, Pin, Gamma, c_d, tsb, olap, dc_darm_offset);

% *************************************************************************


% Intensity Noise ###########################################################
disp('Calculating Intensity Noise...')
RIN = ones(size(ff)) * 3e-8;

% High frequency coupling of RIN to L-
% (calculated in dcr.m)
epsilon = 1.1973e-13;  % For a 20 pm offset

rin_response = zpk(-2*pi*par.darm.cavpole,-2*pi*1,1);
rin_response = abs(mybodesys(rin_response,ff));


iss = [ff epsilon.*RIN.*rin_response];
% # # # # ## # # # ## # # # ## # # # ## # # # ## # # # ## # # # ## # # # #

% Frequency Noise ###########################################################
disp('Calculating Frequency Noise...')
dnu = ones(size(ff)) * 0.3e-6;

% 3x lower noise because of 10x more light on REFL61

delta_fc = 2; % approximately a 2% pole mismatch

freq_response = zpk([],-2*pi*1,2*pi*4763/2)*7e-17;
freq_response = abs(mybodesys(freq_response,ff));

refl = [ff delta_fc.*dnu.*freq_response];
% # # # # ## # # # ## # # # ## # # # ## # # # ## # # # ## # # # ## # # # #



load /home/rana/data/srd_curve.mat

toto = interp1(seis_rub(:,1),seis_rub(:,2),ff,'spline',0).^2 +...
       interp1(mich(:,1),mich(:,2),ff,'spline',0).^2 +...
       interp1(prc(:,1),prc(:,2),ff,'spline',0).^2 +...
       sus_electronics.^2 +...
       shot0.^2 +...
       tnetm.^2 +...
       x_int.^2 +...
       ang_noise(:,2).^2 +...
       iss(:,2).^2 +...
       refl(:,2).^2;

toto = sqrt(toto);

dc_range = InspiralRange(ff,toto/L)/1000;
[UL,snr,integr,f] = stochasticUL(0.90, 1, 'LHO-LLO', toto, toto, ff);

%subplot(122)
subplot('Position',[0.53,0.08,0.47,0.87]);
curr = loglog(prc(:,1),prc(:,2),'color',[0.6 0 0.7],'LineStyle','-');
hold on
loglog(mich(:,1),mich(:,2),'color',[0.3 0.3 1],'LineStyle','-');
loglog(ff,x_int,'color',[0 1 1],'LineStyle','--');
loglog(ff,tnetm,'color',[0.7 0.7 0.2],'LineStyle','--');
loglog(iss(:,1),iss(:,2),'color',[1 1 0],'LineStyle','-');
loglog(refl(:,1),refl(:,2),'color',[0.6 0.47 .7],'LineStyle','-');
loglog(ff,shot0,'color',[0.3 0 0.8],'LineStyle','--');
loglog(seis_rub(:,1),seis_rub(:,2),'color',[0.6 0.4 0.3],'LineStyle','-');
loglog(ang_noise(:,1),ang_noise(:,2),'color',[0.85 0 0.17],'LineStyle','-');
loglog(ff,sus_electronics,'color',[1 0.4 0.7],'LineStyle','--');
loglog(ff,toto,'color',[1 .5 0],'LineStyle','-.','LineWidth',2);
loglog(f_srd,x_srd,'color',[0.3 0 0.3],'LineStyle','-.');

hold off
axis([29 3100 1e-20 3e-17])
grid on
grid minor
xlabel('Frequency [Hz]','FontWeight','demi','Color','black','FontSize',18)
%ylabel('Displacement [m/\surdHz]','FontWeight','demi','Color','black','FontSize',18)
%title(['DC Readout: ' num2str(dc_darm_offset*1e12,'%9.0f') ' pm offset'])
title('DC Readout, 30 W')

set(gca,'YTickLabel',[])

legh = legend('PRC',...
       'MICH',...
       'Mirror Thermal',...
       'Wire Thermal',...
       'Intensity Noise',...
       'Frequency Noise',...
       'Shot Noise',...
       'Seismic',...
       'Angle Controls',...
       'SUS electronics',...
       ['Total (' num2str(dc_range,'%9.1f') ' Mpc)'],...
       'SRD');
set(legh,'FontSize',12)

qux = [ff toto];
save DCnoise.txt qux -ascii 



