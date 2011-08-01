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
    % DC. So probeSens will be a ?5xNprobe? matrix.
    %
    % probeSens is the matrix that translates the probes into the sensors.
    % Let's just make a temporary variable which shows how probes become
    % sensors.
    
    %transProbeSens = { ASI, ASI
                        
    
    
end