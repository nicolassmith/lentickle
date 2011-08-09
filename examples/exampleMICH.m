% script to calculate loop gains and noise transfer functions for the MICH
% example.

run ../setupLentickle;

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

DIFF2ASQ = pickleTF(results,'DIFF_ctrl','AS_Q','ol');
DIFF2ASI = pickleTF(results,'DIFF_ctrl','AS_I','ol');

figure(2)
clf
zplotlog(f,DIFF2ASQ,'b')
hold on
subplot(2,1,2)
hold on
zplotlog(f,DIFF2ASI,'r')
legend('ASQ','ASI')

COMM2REFLQ = pickleTF(results,'COMM_ctrl','REFL_Q','ol');
COMM2REFLI = pickleTF(results,'COMM_ctrl','REFL_I','ol');

figure(3)
clf
zplotlog(f,COMM2REFLQ,'b')
hold on
subplot(2,1,2)
hold on
zplotlog(f,COMM2REFLI,'r')
legend('REFLQ','REFLI')

% measurements to display
% Loop gain TFs
% laser noise common mode rejection
% something else?
