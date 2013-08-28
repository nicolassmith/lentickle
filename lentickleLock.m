function [newCucumber,lockPos] = lentickleLock(cucumber,errSetPoint)
    % lentickleLock
    % This function calculates the position offset that ensures the DC
    % values of the DOF signals are equal to errSetPoint.
    %
    % Syntax: [newCucumber,lockPos] = lentickleLock(cucumber,errSetPoint)
    % input arguments:
    % cucumber - the initial lentickle control system model
    % errSetPoint - a nDOFx1 vector of the desired DC values of the error
    %    signals. These are usually zeros. If you would like an error
    %    signal to be ignored and have that degree of freedom remain
    %    unchanged, put NaN into the matrix element.
    % output arguments:
    % newCucumber - the modified lentickle control system model, with
    %    offsets applied
    % lockPos - the position offsets in the Optickle drive basis that
    %    define the set point.
    %
    % WARNING: When calculating results, do not include lockPos along with
    % the modified cucumber. This will apply the offsets twice.

    % wrap around setOperatingPoint
    % get the required variables
    opt = cucumber.opt;
    vOffset = reshape(errSetPoint,length(errSetPoint),1);
    mSense = cucumber.sensDof * cucumber.probeSens;
    mDrive = cucumber.mirrDrive * cucumber.dofMirr;

    % remove the NaN error signals (we will not servo those)
    dofSubset = not(isnan(vOffset));
    
    vOffset = vOffset(dofSubset);
    mSense = mSense(dofSubset,:);
    mDrive = mDrive(:,dofSubset);

    % call setOperatingPoint
    [opt, lockPos] = setOperatingPoint(opt, mDrive, mSense, vOffset);

    newCucumber = cucumber;
    newCucumber.opt = opt;
end
