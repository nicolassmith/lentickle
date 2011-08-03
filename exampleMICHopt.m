function opt = exampleMICHopt()
    % returns a simple RF power recycled michelson opt model, for use with
    % the lentickle example.

    
    %% Define Parameters
    fMod = 25e6; % RF modulation frequency (Hz)
    gMod = 0.1; % RF modulation depth
    laserAmp = sqrt(1); % laser amplitude (sqrtW)
    lossY = 1e-6; % power lost on reflection from Y mirror (for aome assymetry)
    pendOmega = 2*pi*1.2; % pendulum angular frequency (rad/s)
    mass = 10; % optic mass (kg)
    
    Tpr = .03;
    
    % arm lenths
    Lprbs = 1;
    Lavg = 10; %average arm lenth
    Lschnupp = 0.2; %schnupp assymetry
    
    
    %% create an opt object
    % we will make a simple RF michelson
    opt = Optickle([0; fMod; -fMod]);
    
    % make the laser
    opt = addSource(opt, 'Laser', [laserAmp; 0; 0]);
    
    % add audio modulators for Laser amplitude and phase noise
    opt = addModulator(opt, 'AM', 1);
    opt = addModulator(opt, 'PM', 1i);
    
    % link, output of Laser is PM->out
    opt = addLink(opt, 'Laser', 'out', 'AM', 'in', 0);
    opt = addLink(opt, 'AM', 'out', 'PM', 'in', 0);
    
    % rf modulator
    opt = addRFmodulator(opt, 'Mod1', fMod, 1i * gMod);
    
    opt = addLink(opt, 'PM', 'out', 'Mod1', 'in', 1);
    
    % lets make some optics
    
    % PR and BS
    opt = addMirror(      opt, 'PR',  0, 0, Tpr, 0);
    opt = addBeamSplitter(opt, 'BS', 45, 0, 0.5);
    
    % X and Y mirrors
    opt = addMirror(opt, 'MX', 0, 0, 1e-6, 0);
    opt = addMirror(opt, 'MY', 0, 0, 1e-6, lossY);
    
    % mechanical response
    dampRes = [0.01 + 1i, 0.01 - 1i];
    opt = setMechTF(opt, 'MX', zpk([], -pendOmega * dampRes, 1 / mass));
    opt = setMechTF(opt, 'MY', zpk([], -pendOmega * dampRes, 1 / mass));
    opt = setMechTF(opt, 'BS', zpk([], -pendOmega * dampRes, 1 / mass));
    
    % connect them up
    opt = addLink(opt, 'Mod1', 'out', 'PR', 'bk', 1);
    opt = addLink(opt, 'PR', 'fr', 'BS', 'frA', Lprbs);
    opt = addLink(opt, 'BS', 'frB', 'PR', 'fr', Lprbs);
    opt = addLink(opt, 'BS', 'frA', 'MY', 'fr', Lavg-Lschnupp/2);
    opt = addLink(opt, 'BS', 'bkA', 'MX', 'fr', Lavg+Lschnupp/2);
    opt = addLink(opt, 'MY', 'fr', 'BS', 'frB', Lavg-Lschnupp/2);
    opt = addLink(opt, 'MX', 'fr', 'BS', 'bkB', Lavg+Lschnupp/2);
    
    % make beam sinks at REFL and AS ports and Trans
    
    opt = addSink(opt, 'REFLport');
    opt = addSink(opt, 'ASport');
    opt = addSink(opt, 'TRXport');
    opt = addSink(opt, 'TRYport');
    
    
    % final links
    opt = addLink(opt, 'PR', 'bk', 'REFLport', 'in', 1);
    opt = addLink(opt, 'BS', 'bkB', 'ASport', 'in', 1);
    opt = addLink(opt, 'MX', 'bk', 'TRXport', 'in', 1);
    opt = addLink(opt, 'MY', 'bk', 'TRYport', 'in', 1);

    % now probes
    opt = addProbeIn(opt, 'REFL DC', 'REFLport', 'in', 0, 0);   % DC
    opt = addProbeIn(opt, 'REFL I1', 'REFLport', 'in', fMod, 0);  % demod I
    opt = addProbeIn(opt, 'REFL Q1', 'REFLport', 'in', fMod, 90); % demod Q
    
    opt = addProbeIn(opt, 'AS DC', 'ASport', 'in', 0, 0);   % DC
    opt = addProbeIn(opt, 'AS I1', 'ASport', 'in', fMod, 0);  % demod I
    opt = addProbeIn(opt, 'AS Q1', 'ASport', 'in', fMod, 90); % demod Q
    
    opt = addProbeIn(opt, 'TRX DC', 'TRXport', 'in', 0, 0); 
    opt = addProbeIn(opt, 'TRY DC', 'TRYport', 'in', 0, 0);
end