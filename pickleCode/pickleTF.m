% mTF = pickleTF(rslt, nameFrom, nameTo)
%   get transfer matrix from one test-point to another
%
% nameIn and nameOut can be any of the following strings:
% sens, err, ctrl, corr, mirr

function mTF = pickleTF(rslt, nameFrom, nameTo)

  names = rslt.testPoints;
  namesUpper = rslt.testPointsUpper;

  % look for special readout name
  namesReadOut = {'angle', 'dof', 'spot'};
  nameRoFrom = {'mirr', 'mirr', 'mirr'};

  nRO = find(strcmp(nameTo, namesReadOut));
  if ~isempty(nRO)
    nameTo = nameRoFrom{nRO};
  end
  
  % check names input and output names
  nIn = find(strcmp(nameFrom, names));
  nOut = find(strcmp(nameTo, names));
  if isempty(nIn)
    error('Invalid input name "%s".', nameIn)
  end
  if isempty(nOut)
    error('Invalid output name "%s".', nameOut)
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
    
end

