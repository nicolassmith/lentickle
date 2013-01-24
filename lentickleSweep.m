% [x, sensDC, sigDC, fDC] = lentickleSweep(cucumber, ...
%   dofName, sweepStart, sweepEnd, numPoint)
%
%   calls sweepLinear with arguments constructed to sweep the given DOF
%
% the results are from sweepLinear, with
%   x = DOF position values from sweepStart to sweepEnd
%   sensDC = cucumber.probeSens * sigDC

function [x, sensDC, sigDC, fDC] = lentickleSweep(cucumber, ...
  dofName, sweepStart, sweepEnd, numPoint)

  % convert name to index
  if ischar(dofName)
    nDof = find(strcmp(dofName, cucumber.dofNames), 1);
    if isempty(nDof)
      error('No match for DOF %s', dofName)
    end
  elseif isnumeric(dofName) && numel(dofName) == 1
    nDof = dofName;
  else
    error('Ambiguous dofName (must be string, or integer)')
  end
  
  % make pos vector
  x = sweepStart + (sweepEnd - sweepStart) * (0:numPoint - 1)' / (numPoint - 1);
  pos = cucumber.mirrDrive * cucumber.dofMirr(:, nDof) * x';
  
  % sweep
  [fDC, sigDC] = sweep(cucumber.opt, pos);
  
  % make sensDC
  sensDC = cucumber.probeSens * sigDC;
end