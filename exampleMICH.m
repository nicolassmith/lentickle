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

COMM_OLG = [f,1-1./pickleTF(results,'COMM','COMM','cl')];
DIFF_OLG = [f,1-1./pickleTF(results,'DIFF','DIFF','cl')];


SRSbode(DIFF_OLG)