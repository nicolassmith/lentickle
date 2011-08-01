function cucumber = exampleMICHcucumber(opt)
    % returns a simple cucmber control system structure for the michelson
    % example for lentickle
    %
    % Some ASCII art
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
                        
    
    
    
    
    %% Store all the needed arrays in the cucumber
    cucumber.probeSens = probeSens;
    cucumber.sensNames = sensNames;
    cucumber.mirrDrive = mirrDrive;
    cucumber.mirrNames = mirrNames;
end
