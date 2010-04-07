% pickle.result = pickleEngine(pickle, pos, f, sigAC, mMech)
%   generate pickle result matrices, TFs, etc.
%   sigAC and mMech will be generated if not given as arguments
%

function rslt = lentickleEngine(lentickle, pos, f, sigAC, mMech)
  
  pp = lentickle.param;

  
  % sizes of things
  Nfreq = numel(f);
  Nsens = pp.Nsens;
  Ndof = pp.Ndof;
  Nmirr = pp.Nmirr;
  
  % call tickle to compute fields and TFs
  if( nargin < 5 )
    [fDC,sigDC,sigAC, mMech] = tickle(lentickle.opt, pos, f);
  end
  
  % get loop TFs
  hCtrl = pickleMakeFilt(f, pp.ctrlFilt);
  hMirr = pickleMakeFilt(f, pp.mirrFilt);
  hPend = pickleMakeFilt(f, pp.pendFilt);
  
  %%%%%%%%%%%%%%%%% initialize result matrices
  rslt.Nfreq = Nfreq;
  rslt.Nsens = Nsens;
  rslt.Ndof = Ndof;
  rslt.Nmirr = Nmirr;
  
  rslt.sensCL = zeros(Nsens, Nsens, Nfreq);
  rslt.errCL = zeros(Ndof, Ndof, Nfreq);
  rslt.ctrlCL = zeros(Ndof, Ndof, Nfreq);
  rslt.corrCL = zeros(Nmirr, Nmirr, Nfreq);
  rslt.mirrCL = zeros(Nmirr, Nmirr, Nfreq);
  
  rslt.errOL = zeros(Ndof, Ndof, Nfreq);
  
  rslt.sensErr = zeros(Ndof, Nsens, Nfreq);
  rslt.errCtrl = zeros(Ndof, Ndof, Nfreq);
  rslt.ctrlCorr = zeros(Nmirr, Ndof, Nfreq);
  rslt.corrMirr = zeros(Nmirr, Nmirr, Nfreq);
  rslt.mirrSens = zeros(Nsens, Nmirr, Nfreq);
  rslt.corrSens = zeros(Nsens, Nmirr, Nfreq);
  
  rslt.mMirr = zeros(Nmirr, Nmirr, Nfreq);
  rslt.mirrSpot = zeros(Nmirr, Nmirr, Nfreq);
  
  % compute result matrices for each frequency
  probeSens = pp.probeSens;
  sensDof = pp.sensDof;
  dofMirr = pp.dofMirr;
  mirrDrive = pp.mirrDrive;
  driveMirr = pp.driveMirr;
  
  eyeSens = eye(Nsens);
  eyeDof = eye(Ndof);
  eyeMirr = eye(Nmirr);

  % prevent scale warnings
  sWarn = warning('off', 'MATLAB:nearlySingularMatrix');

  for n = 1:Nfreq
    % use maps to produce mirrSens
    mirrSens = probeSens * sigAC(:, :, n) * mirrDrive;
    
    % make piecewise TFs
    errCtrl = diag(hCtrl(n, :));
    ctrlCorr = diag(hMirr(n, :)) * dofMirr;
    corrMirr = diag(hPend(n, :));

    % make half-loop pairs
    corrSens = mirrSens * corrMirr;
    sensCorr = ctrlCorr * errCtrl * sensDof;
    
    % make open-loop TFs
    sensOL = corrSens * sensCorr;
    errOL = sensDof * corrSens * ctrlCorr * errCtrl;
    ctrlOL = errCtrl * sensDof * corrSens * ctrlCorr;
    corrOL = sensCorr * corrSens;
    mirrOL = corrMirr * sensCorr * mirrSens;
    
    % store results
    rslt.sensErr(:, :, n) = sensDof;
    rslt.errCtrl(:, :, n) = errCtrl;
    rslt.ctrlCorr(:, :, n) = ctrlCorr;
    rslt.corrMirr(:, :, n) = corrMirr;
    rslt.mirrSens(:, :, n) = mirrSens;
    rslt.corrSens(:, :, n) = corrSens;
    
    rslt.errOL(:, :, n) = errOL;

    rslt.sensCL(:, :, n) = inv(eyeSens - sensOL);
    rslt.errCL(:, :, n) = inv(eyeDof - errOL);
    rslt.ctrlCL(:, :, n) = inv(eyeDof - ctrlOL);
    rslt.corrCL(:, :, n) = inv(eyeMirr - corrOL);
    rslt.mirrCL(:, :, n) = inv(eyeMirr - mirrOL);
    
    rslt.mMirr(:, :, n) = driveMirr * mMech(:, :, n) * mirrDrive;
    
%    rslt.mirrSpot(:, :, n) = probeSpot * sigAC(:, :, n) * mirrDrive;
  end

  % reset scale warning state
  warning(sWarn.state, sWarn.identifier);
  
  % copy some parameter matrices
  rslt.mirrDof = pp.mirrDof;
  
  % test point names
  rslt.testPoints = {'sens', 'err', 'ctrl', 'corr', 'mirr'};
  rslt.Ntp = numel(rslt.testPoints);
  
  % make capitalized version of names
  rslt.testPointsUpper = rslt.testPoints;
  for n = 1:rslt.Ntp
    nameTmp = rslt.testPoints{n};
    nameTmp(1) = upper(nameTmp(1));
    rslt.testPointsUpper{n} = nameTmp;
  end
