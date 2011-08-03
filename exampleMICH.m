% script to calculate loop gains and noise transfer functions for the MICH
% example.

setupLentickle;

opt = exampleMICHopt();
cucumber = exampleMICHcucumber(opt);
f = logspace(0,4,500).';

results = lentickleEngine(cucumber,[],f);

% try to calc a TF

TF = [f,pickleTF(results,'AM','AS_Q','cl')];

%SRSbode(TF)

COMM_OLG = 1-1./pickleTF(results,'COMM','COMM','cl');
DIFF_OLG = 1-1./pickleTF(results,'DIFF','DIFF','cl');

figure(1)
clf
zplotlog(f,DIFF_OLG,'b')
hold on
subplot(2,1,2)
hold on
zplotlog(f,COMM_OLG,'r')
legend('DIFF','COMM')

DIFF2ASQ = pickleTF(results,'DIFF','AS_Q','cl');
DIFF2ASI = pickleTF(results,'DIFF','AS_I','cl');

figure(2)
clf
zplotlog(f,DIFF2ASQ,'b')
hold on
subplot(2,1,2)
hold on
zplotlog(f,DIFF2ASI,'r')
legend('ASQ','ASI')

COMM2REFLQ = pickleTF(results,'COMM','REFL_Q','cl');
COMM2REFLI = pickleTF(results,'COMM','REFL_I','cl');

figure(3)
clf
zplotlog(f,COMM2REFLQ,'b')
hold on
subplot(2,1,2)
hold on
zplotlog(f,COMM2REFLI,'r')
legend('REFLQ','REFLI')
