function opt = exampleMICHopt()
    % returns a simple RF michelson opt model, for use with the lentickle
    % example.

    
    %% Define Parameters
    fMod = 25e6; % RF modulation frequency (Hz)
    gMod = 0.1; % RF modulation depth
    laserAmp = sqrt(1); % laser amplitude (sqrtW)
    
    
    %% create an opt object
    opt = Optickle([0 fMod -fMod]);
    
    % make the laser
    opt = addSource(opt, 'Laser', laserAmp);
    
    % add audio modulators for Laser amplitude and phase noise
    opt = addModulator(opt, 'AM', 1);
    opt = addModulator(opt, 'PM', 1i);
    
    % link, output of Laser is PM->out
    opt = addLink(opt, 'Laser', 'out', 'AM', 'in', 0);
    opt = addLink(opt, 'AM', 'out', 'PM', 'in', 0);
    
    % rf modulator
    opt = addRFmodulator(opt, 'Mod1', fMod, 1i * gMod);
    
    opt = addLink(opt, 'PM', 'out', 'Mod1', 'in', 5);
    
    
end