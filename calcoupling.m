% get calibrated noise couplings

darmsens = 'omc';
eligoModel; %create results

% calibrate OMC_PD in terms of DARM meters

calOMC_DARMm = 1./((pickleTF(results,'EX','OMC_PD','cl')-pickleTF(results,'EY','OMC_PD','cl'))/2);

% calibrate phase to frequency

calFreq_Phase = 1i*f;

% get AM noise coupling

AMuncal = pickleTF(results,'AM','OMC_PD','cl');

AMcal = calTF(AMuncal,calOMC_DARMm);

% get PM noise coupling

PMuncal = pickleTF(results,'PM','OMC_PD','cl');

PMcal = calTF(PMuncal,calOMC_DARMm,calFreq_Phase);


% do again for RF

darmsens = 'asq';
eligoModel; %create results

% calibrate OMC_PD in terms of DARM meters

calASQ_DARMm = 1./((pickleTF(results,'EX','AS_Q','cl')-pickleTF(results,'EY','AS_Q','cl'))/2);

% get AM noise coupling

AMuncalAS = pickleTF(results,'AM','AS_Q','cl');

AMcalAS = calTF(AMuncalAS,calASQ_DARMm);

% get PM noise coupling

PMuncalAS = pickleTF(results,'PM','AS_Q','cl');

PMcalAS = calTF(PMuncalAS,calASQ_DARMm,calFreq_Phase);


% plot

figure(124)
SRSbode([f,AMcal],[f,AMcalAS])
legend('DC readout AM coupling','RF readout AM coupling')
xlabel('Frequency (Hz)')
ylabel('m/RIN')

figure(125)
SRSbode([f,PMcal],[f,PMcalAS])
legend('DC readout FM coupling','RF readout FM coupling','Location','SE')
xlabel('Frequency (Hz)')
ylabel('m/Hz')
