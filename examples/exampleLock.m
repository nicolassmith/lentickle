%% Setpoint locking example
% scrtipt to demonstrate how to find the operating point where error signals 
% are nulled.

run ../setupLentickle.m

%% Set up optickle model and cucumber
% we will use the example fabry perot model that comes with Optickle and 
% create a simple corresponding cucumber
cucumber.opt = optFP;

cucumber.sensNames = {'REFL_I','REFL_Q'};
cucumber.probeSens = sparse(2,cucumber.opt.Nprobe);
cucumber.probeSens(1,getProbeNum(cucumber.opt,'REFL_I')) = 1;
cucumber.probeSens(2,getProbeNum(cucumber.opt,'REFL_Q')) = 1;

cucumber.mirrNames = {'IM','EM'};
cucumber.mirrDrive = sparse(cucumber.opt.Ndrive,2);
cucumber.mirrDrive(getDriveNum(cucumber.opt,'IX'),1) = 1;
cucumber.mirrDrive(getDriveNum(cucumber.opt,'EX'),2) = 1;

cucumber.sensDof = [ 1 , 0 ]; % REFL_I is length sensor
cucumber.dofNames = {'length'};

cucumber.ctrlFilt = [filtZPK([100],[0],1)];
cucumber.setUgfDof = [ 1000 ];
cucumber.dofMirr = [ -1 ; 1 ]; % length feeds back to ETM

unityFilt = filtZPK([],[],1);
cucumber.mirrFilt = [ unityFilt , unityFilt ];
cucumber.pendFilt = [ unityFilt , unityFilt ]; % we're just ignoring the pendulum

%% Find the desired error signal value

[x, sensDC, sigDC, fDC] = lentickleSweep(cucumber,'length',-1e-8,1e-8,100);

dofDC = cucumber.sensDof * sensDC;

% Find the value of the error signal
errorOffset = -max(dofDC(1,:))/3;

%% Use lentickleLock to calculate the POS offset

% first the zero detuning pos offset
posZero = lentickleLock(cucumber,0);

% and the detuned pos offset
posDetune = lentickleLock(cucumber,errorOffset);

%% Calculate transfer functions for the different detunings

f = logspace(-1,4,1000);

resultsZero = lentickleEngine(cucumber,posZero,f);
resultsDetune = lentickleEngine(cucumber,posDetune,f);

tfZero = 1-1./pickleTF(resultsZero,'length','length');
tfDetune = 1-1./pickleTF(resultsDetune,'length','length');

figure(33)
subplot(2,1,1)
loglog(f,abs(tfZero),'r',f,abs(tfDetune),'b');
title('Length sensor response to end mirror excitation')
ylabel('Magnitude (m/Hz)')
legend('Tuned','Detuned')
xlim([min(f) max(f)])
grid on
subplot(2,1,2)
semilogx(f,180/pi*angle(tfZero),'r',f,180/pi*angle(tfDetune),'b');
ylabel('Phase (degrees)')
xlabel('Frequency (Hz)')
xlim([min(f) max(f)])
grid on