% mTF = pickleTF(rslt, nameFrom, nameTo)
%   get transfer matrix from one test-point to another
%
% nameIn and nameOut can be any of the following strings:
% sens, err, ctrl, corr, mirr

function mTF = pickleTF(rslt, nameFrom, nameTo, varargin)

  names = rslt.testPoints;
  namesUpper = rslt.testPointsUpper;

  % look for special readout name
  namesReadOut = {'angle', 'dof', 'spot'};
  nameRoFrom = {'mirr', 'mirr', 'mirr'};

  nRO = find(strcmp(nameTo, namesReadOut));
  if ~isempty(nRO)
    nameTo = nameRoFrom{nRO};
  end
  
  % hijack here to look for single dimensional TFs
  mirrNames = rslt.mirrNames;
  sensNames = rslt.sensNames;
  dofNames = rslt.dofNames;
  
  ctrlFrom = 0;
  ctrlTo = 0;
    
  % if you are looking for a ctrl channel, strip off _ctrl and make a note
  if numel(nameFrom)>4 && strcmpi(nameFrom(end-4:end),'_ctrl')
      ctrlFrom = 1;
      nameFrom = nameFrom(1:end-5);
  end
  
  if numel(nameTo)>4 && strcmpi(nameTo(end-4:end),'_ctrl')
      ctrlTo = 1;
      nameTo = nameTo(1:end-5);
  end
  
  % find the singular test point names in the name list
  singNames = [mirrNames,sensNames,dofNames];
  
  singFrom = find(strcmpi(nameFrom,singNames),1);
  singTo = find(strcmpi(nameTo,singNames),1);
  
  if ~isempty(singFrom)
     nameFrom = 'mirr'; % what we are looking for is a mirror
     Nmirr = numel(mirrNames);
     Nsens = numel(sensNames);
     if singFrom > Nmirr
         nameFrom = 'sens'; % no wait, it's a sensor
         singFrom = singFrom - Nmirr;
          if singFrom > Nsens
             nameFrom = 'dof'; % actually it's a dof
             singFrom = singFrom - Nsens;
             if ctrlFrom
                 nameFrom = 'ctrl'; % really, really it's a ctrl
             end
         end
     end
     if ~isempty(singTo)
        nameTo = 'mirr';
        if singTo > Nmirr
          nameTo = 'sens'; % no wait, it's a sensor
          singTo = singTo - Nmirr;
            if singTo > Nsens
              nameTo = 'dof'; % actually it's a dof
              singTo = singTo - Nsens;
              if ctrlTo
                 nameTo = 'ctrl'; % really, really it's a ctrl
              end
            end
        end
     else
         error('Both channels must be valid single channel testpoints (or neither)')
     end
  else
      if ~isempty(singTo)
          error('Both channels must be valid single channel testpoints (or neither)')
      end
  end
  
  % now we have determined which test point class the single channels
  % belong to, we can get the full 3d matrix, and pick out the right
  % channels at the end.
  
  % check names input and output names
  nIn = find(strcmp(nameFrom, names));
  nOut = find(strcmp(nameTo, names));
  if isempty(nIn)
    error('Invalid input name "%s".', nameFrom) %bug
  end
  if isempty(nOut)
    error('Invalid output name "%s".', nameTo) %bug
  end

  % get initial matrix
  if nIn == nOut
    mTF = eye(rslt.(['N' nameFrom]));
  else
    nNext = nIn + 1;
    if nNext > rslt.Ntp
      nNext = 1;
    end
    nameTF = [names{nIn} namesUpper{nNext}];
    mTF = rslt.(nameTF);
    nIn = nNext;
  end

  % compute matrix product
  while nIn ~= nOut
    nNext = nIn + 1;
    if nNext > rslt.Ntp
      nNext = 1;
    end
    nameTF = [names{nIn} namesUpper{nNext}];
    mTF = getProdTF(rslt.(nameTF), mTF);
    nIn = nNext;
  end
  
  % deal with special readout matrix
  if ~isempty(nRO)
    switch nRO
      case 1  %%%%%%%%%%%%%%%%%%% angle
	mTF = getProdTF(rslt.mMirr, mTF);
      case 2  %%%%%%%%%%%%%%%%%%% dof
	mTF = getProdTF(rslt.mirrDof, rslt.mMirr, mTF);
      case 3  %%%%%%%%%%%%%%%%%%% spot
	mTF = getProdTF(rslt.mirrSpot, mTF);
      otherwise
	error('Internal read out problem.')
    end
  end
    
  if numel(varargin) && strcmpi(varargin{1},'cl')
      clTF = rslt.([nameFrom 'CL']);

      mTF = getProdTF(mTF, clTF);
  end
  
  % now we squeeze if we were asking for single channels
  if ~isempty(singTo) && ~isempty(singFrom)
      mTF = squeeze(mTF(singTo,singFrom,:));
  end
end

