function results = getEligoResults(f,inPower,DARMoffset,DARMsens)
    % produces an eLIGO lentickle results structure
    %
    % results = getEligoResults(inPower,DARMoffset,DARMsens)

    if nargin < 4 % default DARMsens value
        DARMsens = 'omc';
    end
    
    par = paramPowerL1(inPower, DARMoffset);
    par = paramEligo_01_L1(par); 
    opt = optEligo(par);
    opt = probeSens(opt, par);
    
    lentickle = lentickleEligo(opt,DARMsens);

    % tickle
    [fDC,sigDC,sigAC, mMech] = tickle(lentickle.opt, [], f);     
    
    % get loop calculations
    results = lentickleEngine(lentickle,[],f,sigAC,mMech);

end