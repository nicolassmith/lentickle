%% Power Recycled Michelson Lentickle Example
% script to calculate loop gains and noise transfer functions for the MICH
% example.

%% Set up paths
run ../setupLentickle; 

%% Interferometer Model
% first we will set up our interferometer model, including the optickle
% plant (handled by Optickle) and the rest of the control system (handled
% by lentickle).

opt = exampleMICHopt(); % create the opt object
cucumber = exampleMICHcucumber(opt); % create the cucumber structure
                                     % look at exampleMICHcucumber.m for
                                     % more info about the cucumber.
f = logspace(0,4,500).'; % choose the frequency array we will use

%% Closed loop results
% We will now call the lentickleEngine function to calculate the closed
% loop transfer functions of the control system. As arguments, it takes the
% cucumber, a 'pos' array which has offsets of all the Optickle drives
% (note: these are 'drives' not 'mirrors'), and the frequency array.

results = lentickleEngine(cucumber,[],f); % calculate all results

%% Transfer functions
% All the transfer functions can be extracted from the results structure,
% and the pickleTF function makes that easy.

%% Open Loop Gains
% We will calculate the open loop gains of our two degrees of freedom, the
% differential and common modes of the arms, 'DIFF' and 'COMM'. pickleTF
% will easily give us the closed loop gain, and calulating the open loop
% gain from that is fairly easy. (OLG = 1 - 1./CLG)

COMM2REFLI = pickleTF(results,'COMM_ctrl','REFL_I');

zplotlog(f,COMM2REFLI)


% measurements to display
% Loop gain TFs
% laser noise common mode rejection
% something else?
