function cucumber = exampleMICHcucumber(opt,pos)
    % returns a simple cucmber control system structure for the michelson
    % example for lentickle
    %
    % Input: Optickle opt object from lentickle MICH opt example.
    %
    % Here we will describe the 'cucumber,' which is a structure variable
    % containing the model of the control system.
    %
    % Lentickle expects a control system made like this one:
    %
    % ---> sensDof -> ctrlFilt -> dofMirr -> mirrFilt -> pendFilt ---
    % |                                                             |
    % |                                                             |
    % ------ probeSens <- [Optickle Model] <- mirrDrive <------------
    %
    % All the components that have Filt in the name represent a 1D array of
    % filters. So if you have 4 DOFs, your ctrlFilt is a 1x4 array of
    % filters. 
    %
    % pendFilt is intended to represent the true mechanical response of
    % each 'mirror.' (That is, it's the tranfer function between the
    % control signal and the input of the Optickle model, which is meters
    % for mirrors). mirrFilt, on the other hand, is used to represent a
    % 'compensation' filter, which may be an approximation of the inverse
    % of the mechanical response.
    %
    % The others are all static matrices, sensDof is commonly known as the
    % 'input matrix' and dofMirr is the 'output matrix.' 
    %
    % probeSens and mirrDrive are typically matrices of ones and zeros
    % only, and they are typically not square matricies, meaning that there
    % will usually be more 'probes' than 'sensors' and likewise more
    % 'drives' than 'mirrors.' They just allow the user to only deal with a
    % subset of all the probe and drive points that might exist in the
    % Optickle model. (For example you may have made a probe of the field
    % inside some cavity for diagnostics, but it will never be part of your
    % control system, so there will be no corresponding 'sensor' for that
    % 'probe.')
    %
    % Normally the overal (open loop) gain of a given degree of freedom
    % would be set simply by the product of the gains around the
    % loop, at times it may be desirable to just choose the unity gain
    % frequency of the loop, this is done using the setUgfDof array. It is
    % a 1xNdof array with the UGF of the nth loop. If you want to ignore a
    % DOF, you can put in NaN and it will just keep the raw loop gain.
    %
    % There are also several arrays for storing the names of mirrors,
    % sensors and dofs.
    
    if nargin<2
        pos = [];
    end
    
    %% First Create probeSens
    % Our opt model has opt.Nprobe probes, and we will choose just 5
    % sensors. These will be AS and REFL at RF (I and Q) as well as AS at
    % DC. So probeSens will be a 5xNprobe matrix.
    %
    % probeSens is the matrix that translates the probes into the sensors.
    % Let's just make a temporary variable which shows how probes become
    % sensors.
    
                    %  probes     sensors
    probeSensPairs = {'REFL I1', 'REFL_I'
                      'REFL Q1', 'REFL_Q'
                      'AS I1',   'AS_I'
                      'AS Q1',   'AS_Q'
                      'AS DC',   'AS_DC'};
                  
	% now we can use this to create our matrix.
    
    Nsens = size(probeSensPairs,1);
    probeSens = sparse(Nsens,opt.Nprobe);
    
    for jSens = 1:Nsens
                  %sensor index, probe index = 1
        probeSens(jSens,getProbeNum(opt,probeSensPairs{jSens,1})) = 1; %#ok<SPRIX>
    end
                        
    % We will also need the list of sensor names
    
    sensNames = probeSensPairs(:,2).';
    
    %% The other boring matrix is mirrDrive
    
                    %  mirrors  drives driveType
    mirrDrivePairs = {'MX',    'MX',   1
                      'MY',    'MY',   1
                      'BS',    'BS',   1
                      'AM',    'AM',   1
                      'PM',    'PM',   1
                      'OSC_AM','Mod1', 'amp'
                      'OSC_PM','Mod1', 'phase'};
                  
	% now we can use this to create our matrix.
    
    Nmirr = size(mirrDrivePairs,1);
    mirrDrive = sparse(opt.Ndrive,Nmirr);
    
    mirrNames = mirrDrivePairs(:,1).';   
    
    for jMirr = 1:Nmirr
                  %drive index, mirror index = 1
        mirrDrive(getDriveNum(opt, mirrDrivePairs{jMirr,2}, mirrDrivePairs{jMirr,3}), jMirr) = 1; %#ok<SPRIX>
    end
                        
    %% Control System Model
    % what we've done so far is just to reduce the number of inputs and
    % outputs to/from the Optickle model to make everything more resonable.
    % Now it's time to actually build the control system model.
    
    %% Input Matrix (sensDof)
    % we will just construct the input matrix we want. For out michelson,
    % let's just define a simple control system of two degrees of freedom,
    % the common mode arm mirror motion, COMM, and the differential mode,
    % DIFF. The ordering of the rows and columns are important, the first
    % sensor definded in probeSens is the fist sensor here.
    
              % REFLI REFLQ ASI ASQ ASDC
    sensDof = [     1     0   0   0    0   % COMM
                    0     0   0   1    0]; % DIFF
    
	% Now that we've defined our DOFs, let's store the names we will use to
	% refer to them.
    
    dofNames = { 'COMM', 'DIFF'};
    
    %% Control Filters (ctrlFilt)
    % These are the feedback filters.
    
               % COMM                DIFF
    ctrlFilt = [ filtZPK([],20,1), filtZPK([],50,1)];
    
    % here we should also store the desired UGF of the loops
                % COMM DIFF
    setUgfDof = [  485  150 ];
    
    %% Output Matrix (dofMirr)
    % remember, order matters.
    
              % COMM DIFF
    dofMirr = [    1    1   % MX
                   1   -1   % MY
                   0    0   % BS
                   0    0   % AM
                   0    0   % PM
                   0    0   % OSC AM
                   0    0]; % OSC PM
               
    %% Pendulum compensation (mirrFilt)
    % We'll just do something really dumb for pendulum compensation: 2
    % zeros at 1Hz and a few poles at 1kHz.
    
    unityFilt = filtZPK([],[],1); % just a flat TF for non-mirrors
    compFilt = filtZPK([1,1],[1000,1000,1000],1); % dumb compensation
    
               % MX       MY       BS       AM        PM        OSCAM     OSCPM
    mirrFilt = [ compFilt compFilt compFilt unityFilt unityFilt unityFilt unityFilt ];
    
    %% Mechanical Response (pendFilt)
    % The mechanical response of the mirrors is defined in the Optickle
    % Model, we should be able to just get the filters from there. Optickle
    % stores them as zpk objects, we need to convert them to mf (matt
    % filter) objects.
    %
    % There are cases where the optical mechanical response will not be the
    % same as the actuator mechanical response. In that case, you'll want
    % to create these filters manually, rather than taking from the
    % Optickle model.
    
    for jMirr = 1:Nmirr
        optic = getOptic(opt,mirrDrivePairs(jMirr,2));
        if numel(optic.mechTF) ~= 0
            pendFilt(jMirr) = zpk2mf(optic.mechTF); %#ok<AGROW>
        else
            % mechTF isn't set, so put in the indentity TF.
            pendFilt(jMirr) = unityFilt; %#ok<AGROW>
        end
    end
    
    %% Store all the needed variables in the cucumber
    cucumber.opt       = opt;
    cucumber.probeSens = probeSens;
    cucumber.sensNames = sensNames;
    cucumber.mirrDrive = mirrDrive;
    cucumber.mirrNames = mirrNames;
    cucumber.sensDof   = sensDof;
    cucumber.dofNames  = dofNames;
    cucumber.ctrlFilt  = ctrlFilt;
    cucumber.setUgfDof = setUgfDof;
    cucumber.dofMirr   = dofMirr;
    cucumber.mirrFilt  = mirrFilt;
    cucumber.pendFilt  = pendFilt;
    
    %% Choosing RF demod phases
    % One step we skipped when making the Optickle model was choosing the
    % demod phases of our RF sensors. Because Lentickle knows something
    % about the control system, we can use it to modify the Optickle model
    % to make certain sensors have maximum response to certain degrees of
    % freedom. (Example, you want DARM to be mostly coupled to AS_Q not
    % AS_I.)
    
    % Let's prepare the arguments for the phasing function.
    
    phaseAS = struct( 'Iname', 'AS_I', ... % name of the I sensor
                      'Qname', 'AS_Q', ... % name of the Q sensor
                      'IorQ',  'Q',    ... % maximize I or Q?
                      'DOF',   'DIFF');    % maximize which DOF?

    phaseREFL = struct( 'Iname', 'REFL_I', ...
                        'Qname', 'REFL_Q', ...
                        'IorQ',  'I',      ...
                        'DOF',   'COMM');
	
	f0 = 150; %choose a frequency (Hz) at which to do the maximization
    
    cucumber = lenticklePhase(cucumber,pos,f0,phaseAS,phaseREFL); % this changes the opt inside cucumber
    
end
