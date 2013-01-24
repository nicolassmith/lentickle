% results = lentickleQuantum(cucumber, results, fMin, fMax)
%   adds quantum noise to the results struct
%
% if fMin and fMax are given, the frequency vector used for
% computing noise is reduced to points which fit in those bounds
%
% fields added to results are:
%   nf = indices in the overall frequency vector at which noise is computed
%   ff = frequency vector for noise = f(nf)
%   noiseAC = output from tickle
%   noiseSens = noise at each sensor = probeSens * noiseAC

function results = lentickleQuantum(cucumber, results, fMin, fMax)

  % frequency vector for noise calculation
  if nargin < 3
    nf = 1:numel(results.f);
  elseif nargin < 4
    nf = find(results.f >= fMin);
  else
    nf = find(results.f >= fMin & results.f <= fMax);
  end
  results.nf = nf;
  results.ff = results.f(nf);
  
  % get shot noise levels
  [~, ~, ~, ~, results.noiseAC] = tickle(cucumber.opt, [], results.ff);
  
  % reduce these to sensor noises
  results.noiseSens = getProdTF(cucumber.probeSens, results.noiseAC);

end
