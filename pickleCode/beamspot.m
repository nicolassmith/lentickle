function  radMeter = beamspot(opt, pickle, sigAC, sigDC, mirr, f)
  
  
  %q = z - i * z0;
  %[R, w] = beamRW(z0, z, lambda)
  
  ch0 = find(strcmp(mirr, pickle.param.mirrNames));
  
  if isempty(ch0)
    error('Invalid mirror name "%s".', mirr)
  end
  
  nf = getFieldIn(opt, mirr, 'fr');
  
  vBasis = getAllFieldBases(opt);
  y = vBasis(nf, 2);
  
  [R, w] = beamRW(imag(y), real(y), opt.lambda); 

  sig = strcat(mirr, '_DC');
  nN = getProbeNum(opt, sig);
  P = sigDC(nN, :);
  
  radMeter = sigAC(nN, pickle.param.vMirr, :) .* w ./ P;
