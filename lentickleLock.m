function lockPos = lentickleLock(cucumber,errSetPoint,startPos)
    % This function locks the error signals in the DOF basis that are given
    
    if nargin<3
        startPos = zeros(cucumber.opt.Ndrive,1);
    end

    % wrap around setOperatingPoint
    % get the required variables
    opt = cucumber.opt;
    vOffset = errSetPoint;
    mSense = cucumber.sensDof * cucumber.probeSens;
    mDrive = cucumber.mirrDrive * cucumber.dofMirr;
    
    % make startPos set the initial pos offset
    opt = setPosOffset(opt,startPos);

    [opt, pos] = setOperatingPoint(opt, mDrive, mSense, vOffset);

    lockPos = pos;
    
end
