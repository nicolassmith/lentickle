function cucumber = lenticklePhase(cucumber,pos,f0,varargin)
    % lenticklePhase
    % This will modify the Optickle opt model in the cucumber to make RF
    % sensors have maximized sensitivity to certain degrees of freedom.
    
    if nargin<4
        error('not enough arguments')
    end
    
    opt = cucumber.opt;
    iSensor = 0;
    
    for sensor = [varargin{:}]
        iSensor = iSensor + 1;
        
        % translate to PROBE names
        
        sensIndexI = find(strcmp(sensor.Iname,cucumber.sensNames),1);
        probeIndexI = find(cucumber.probeSens(sensIndexI,:),1);
        
        sensIndexQ = find(strcmp(sensor.Qname,cucumber.sensNames),1);
        probeIndexQ = find(cucumber.probeSens(sensIndexQ,:),1);
        
        mIQ{iSensor,1} = getProbeName(opt,probeIndexI); %#ok<*AGROW>
        mIQ{iSensor,2} = getProbeName(opt,probeIndexQ);
        mIQ{iSensor,3} = sensor.IorQ;
        
        dofIndex = find(strcmp(sensor.DOF,cucumber.dofNames),1);
        
        dofDrive = cucumber.mirrDrive * cucumber.dofMirr;
        
        mDOF(iSensor,:) = dofDrive(:,dofIndex).';
        
    end
    
    cucumber.opt = setDemodPhases(opt,mIQ,mDOF,pos,f0);
end