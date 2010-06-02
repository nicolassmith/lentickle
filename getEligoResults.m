function [results,opt,fDC,sigDC,sigAC,mMech]...
                        = getEligoResults(f,inPower,DARMoffset,DARMsens)
    % produces an eLIGO lentickle results structure
    %
    % results = getEligoResults(inPower,DARMoffset,DARMsens)

    if nargin < 4 % default DARMsens value
        DARMsens = 'omc';
    end
    
    par = paramH1;
    par = setPower(par,inPower);
    par = paramEligo_00(par);
    opt = optEligo(par);
    opt = probesEligo_00(opt, par);

    posOffset = sparse(zeros(opt.Ndrive,1));
    posOffset(getDriveIndex(opt,'EX')) =  DARMoffset/2;
    posOffset(getDriveIndex(opt,'EY')) = -DARMoffset/2;
    
    lentickle = lentickleEligo(opt,DARMsens);

    % tickle
    [fDC,sigDC,sigAC,mMech] = tickle(lentickle.opt,posOffset,f);     
    
    % get loop calculations
    results = lentickleEngine(lentickle,posOffset,f,sigAC,mMech);
    
end