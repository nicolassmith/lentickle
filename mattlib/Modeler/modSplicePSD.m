%
% psdBoth = modSplicePSD(psdLow, psdHigh)
%

function psdBoth = modSplicePSD(psdLow, psdHigh)

  if( isempty(psdLow) | isempty(psdHigh) )
    psdBoth = [psdLow; psdHigh];
  else
    psdBoth = [psdLow; [NaN, NaN, NaN]; psdHigh];
  end

%  n = find(psdHigh(:,1) >= max(psdLow(:,1)));
%  psdBoth = [psdLow; psdHigh(n,:)];
