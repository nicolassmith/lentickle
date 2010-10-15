% compare laser frequency coupling model/measurement

setupLentickle;

f_numpoints = 200;
f_upperLimit = 5000;
f_lowerLimit = 20;

olcl = 'cl'; %closed loop or open loop

f = logspace(log10(f_lowerLimit),log10(f_upperLimit),f_numpoints).';

inPower = 8;

darmoffset = 10e-12;

% get measurement data

datadir = '/home/nicolas/ligo/eligomeasurements/DCnoisecouplings/freq/2010-10-07';
thisdir = pwd;

cd(datadir)
freqPlot
close
cd(thisdir)

% calculate
results = getEligoResults(f,inPower,darmoffset);

%necesary calibration TFs
CMclg = pickleTF(results,'CM','CM',olcl);
calFreq_Phase = 1i*f;
calOMC_DARMm = 1./((pickleTF(results,'EX','OMC_PD',olcl)-pickleTF(results,'EY','OMC_PD',olcl)));

%calibrated TF
TFmodel = [f,calTF(pickleTF(results,'PM','OMC_PD',olcl),calOMC_DARMm,CMclg.*calFreq_Phase)];

%plot
figure(412)
SRSbode(TFmodel,dataStructure.fTF)
title('Laser Frequency Noise Coupling, DC readout 10pm offset')
ylabel('m/Hz')
legend('model','measurement')
