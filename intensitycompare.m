% compare laser intensity coupling model/measurement

setupLentickle;

f_numpoints = 200;
f_upperLimit = 5000;
f_lowerLimit = 20;

olcl = 'cl'; %closed loop or open loop

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints).';

inPower = 8;

darmoffset = 10e-12;

% get measurement data

datadir = '/home/nicolas/ligo/eligomeasurements/DCnoisecouplings/ISS/2010-10-07';
thisdir = pwd;

cd(datadir)
ISSplot
close
cd(thisdir)

% calculate
results = getEligoResults(f,inPower,darmoffset);

%necesary calibration TF
calOMC_DARMm = 1./((pickleTF(results,'EX','OMC_PD',olcl)-pickleTF(results,'EY','OMC_PD',olcl)));

%calibrated TF
TFmodel = [f,calTF(pickleTF(results,'AM','OMC_PD',olcl),calOMC_DARMm)];

%plot
figure(552)
SRSbode(TFmodel,dataStructure(2).fTF)
title('Laser Intensity Noise Coupling, DC readout 10pm offset')
ylabel('m/RIN')
legend('model','measurement')
