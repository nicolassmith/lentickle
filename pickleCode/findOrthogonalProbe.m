function [Iph,Qph,Flip]=findOrthogonalProbe(opt,pr,loopt,sortport)

el=true; try, loopt; catch el=false; end;
try, sortport; catch sortport=true; end;

Flip=false; % indicates that I and Q are flipped, only happens when sortport=false and pr is a Q phase
isloop=true;
if and(or(isstr(pr),iscell(pr)),el)
    try, n=getLoopNumbers(loopt,pr);
    catch
        isloop=false;
    end
else
    isloop=false;
end
if isloop
    pr=loopt.SENSE{n};
else
    if isstr(pr)
        pr=getProbeNum(opt, pr);
    end
end

name=getProbeName(opt, pr);

ipos=strfind(name,' I');
qpos=strfind(name,' Q');

if and(length(ipos)==1,length(qpos)==0)
    name(ipos+1)='Q';
    Iph=pr;
    Qph=getProbeNum(opt, name);
elseif and(length(ipos)==0,length(qpos)==1)
    name(qpos+1)='I';
    if sortport
      Iph=getProbeNum(opt, name);
      Qph=pr;
    else % first port is the one specified in pr
      Qph=getProbeNum(opt, name);
      Iph=pr;
      Flip=true;
    end;
else
    error(['Cannot phase this port.']);
end
%fprintf('%s\n%s\n',getProbeName(opt, Iph),getProbeName(opt, Qph));
