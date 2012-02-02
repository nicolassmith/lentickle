function cucumber = lenticklePhase(cucumber,pos,f0,varargin)
    % lenticklePhase
    % This will modify the Optickle opt model in the cucumber to make RF
    % sensors have maximized sensitivity to certain degrees of freedom.
    %
    % Syntax: cucumber = lenticklePhase(cucumber,pos,f0,phaseStruct1,phaseStruct2...)
    % cucmber     - lentickle control system model (cucumber)
    % pos         - array of drive offsets (passed directly to tickle)
    % f0          - frequency at which to do maximization
    % phaseStruct - a data structure with the folowing fields
    %     .Iname  - the name of the I phase sensor
    %     .Qname  - the name of the Q phase sensor
    %     .IorQ   - String 'I' or 'Q', tells which phase to maximize
    %     .DOF    - the name of the DOF to drive for maximization
    
    if nargin<4
        error('not enough arguments')
    end
    
    opt = cucumber.opt;
    iSensor = 0;
    
    for sensor = [varargin{:}]
        iSensor = iSensor + 1;
        
        % translate to PROBE names
        
        sensIndexI = find(strcmp(sensor.Iname,cucumber.sensNames),1);
        if numel(sensIndexI)<1
            error(['lenticklePhase Error, no sensor named ' sensor.Iname ' found in the cucumber']);
        end
        probeIndexI = find(cucumber.probeSens(sensIndexI,:),1);
        
        sensIndexQ = find(strcmp(sensor.Qname,cucumber.sensNames),1);
        if numel(sensIndexQ)<1
            error(['lenticklePhase Error, no sensor named ' sensor.Qname ' found in the cucumber']);
        end
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