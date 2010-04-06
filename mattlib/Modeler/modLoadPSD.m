%
% aDat = modLoadPSD(fileName)
%
% returns the amplitude spectrum read from 'fileName'
%

function aDat = modLoadPSD(fileName)

  psdDat = load(fileName);
  if( size(psdDat, 1) > 1 )
    f = psdDat(1,:);
    if( size(psdDat, 1) > 2 )
      avg = sqrt(mean(psdDat(2:end,:)) / 2);	% do I need / 2); ?
      err = std(sqrt(psdDat(2:end,:)) / 2);
    else
      avg = sqrt(psdDat(2:end,:) / 2);
      err = zeros(size(avg));
    end
    aDat = [f; avg; err]';
  else
    aDat = zeros(0, 3);
  end
