% [phiGouy, phiDemod, amp, ampOrth] = getPhases(signalVector)
%
%   written by Lisa Barsotti
%     converted to function format my Matt Evans

function [phiGouy, phiDemod, ampA, ampB] = getPhases(signalVector)

  % convert from input vector to Lisa notations
  if size(signalVector, 1) == 4
    sAI = signalVector(1, :);
    sAQ = signalVector(2, :);
    sBI = signalVector(3, :);
    sBQ = signalVector(4, :);
  elseif size(signalVector, 1) == 2
    sAI = signalVector(1, :);
    sAQ = 0;
    sBI = signalVector(2, :);
    sBQ = 0;
  elseif size(signalVector, 1) == 1
    sAI = signalVector(1, :);
    sAQ = 0;
    sBI = 0;
    sBQ = 0;
  else
    error('Signal not a 4-vector')
  end
  
  % Lisa goes to work...
  a = (sBQ - sAI);
  b = (sAQ + sBI);

  A = b .* sAI + a .* sBI;
  B = b .* (sBI - sAQ)  - a .* (sAI + sBQ);
  C = a .* sAQ - b .* sBQ;
  D = B.^2 - 4 * A .* C;

  if A ~= 0
    s1 = (-B + sqrt(D)) ./ (2 * A); % good solution
    %s2 = (-B - sqrt(D)) ./ (2 * A); % other possible solution
    tD = atan(s1);
  else
    tD = 0;
  end
  
  tG = atan( -(a .* sin(tD) + b .* cos(tD)) ./ ...
              (a .* cos(tD) - b .* sin(tD)));


  % the rotated signals
  sAIp = cos(tD) .* cos(tG) .* sAI + sin(tD) .* cos(tG) .* sAQ + ...
         cos(tD) .* sin(tG) .* sBI + sin(tD) .* sin(tG) .* sBQ;
  sBQp = sin(tD) .* sin(tG) .* sAI - cos(tD) .* sin(tG) .* sAQ - ...
         sin(tD) .* cos(tG) .* sBI + cos(tD) .* cos(tG) .* sBQ;

  % both zero
%   sAQp = -sin(tD) .* cos(tG) .* sAI + cos(tD) .* cos(tG) .* sAQ - ...
%           sin(tD) .* sin(tG) .* sBI + cos(tD) .* sin(tG) .* sBQ;
%   sBIp = -cos(tD) .* sin(tG) .* sAI - sin(tD) .* sin(tG) .* sAQ + ...
%           cos(tD) .* cos(tG) .* sBI + sin(tD) .* cos(tG) .* sBQ;

  % convert from Lisa notation to output arguments
  ampA = sAIp;
  ampB = sBQp;
  phiDemod = tD * 180/pi;
  phiGouy = tG * 180/pi;
  
  


