% compare osc intensity coupling model/measurement

setupLentickle;

f_numpoints = 200;
f_upperLimit = 5000;
f_lowerLimit = 20;

olcl = 'cl'; %closed loop or open loop

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints).';

inPower = 8;

darmoffset = 10e-12;

% get measurement data

datadir = '/home/nicolas/ligo/eligomeasurements/DCnoisecouplings/oan/H1/2010-10-11';
thisdir = pwd;

cd(datadir)
oanPlot
close
cd(thisdir)

% calculate

results = getEligoResults(f,inPower,darmoffset);

calOMC_DARMm = 1./((pickleTF(results,'EX','OMC_PD',olcl)-pickleTF(results,'EY','OMC_PD',olcl)));
TFmodel = [f,-1*calTF(pickleTF(results,'Mod1.amp','OMC_PD',olcl),calOMC_DARMm)];

%plot
figure(432)
SRSbode(TFmodel,dataStructure.fTF)
title('Oscillator Amplitude Noise Coupling, DC readout 10pm offset')
ylabel('m/RIN_s_b')
legend('model','measurement')
