% script to calculate loop gains and noise transfer functions for the MICH
% example.

run ../setupLentickle;

opt = exampleMICHopt();
cucumber = exampleMICHcucumber(opt);
f = logspace(0,4,500).';

results = lentickleEngine(cucumber,[],f);


COMM2REFLI = pickleTF(results,'COMM_ctrl','REFL_I','ol');

figure(3)
zplotlog(f,COMM2REFLI,'r')

% measurements to display
% Loop gain TFs
% laser noise common mode rejection
% something else?
