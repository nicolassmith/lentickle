function [outDb, outPwr] = decibel(input, a);

% [outDb, outPwr] = decibel(input, a) 
% If a > 0, decibel convert the input (magnitude) in magnitude db
% else decibel convert the input (in db) in magnitude

if a > 0
    outDb = 20 * log10(1/input);
    outPwr = input;
    sprintf('A factor %g attenuation is %g db', outPwr, outDb)
else
    outPwr = 10^(input / 20);
    outDb = input;
    sprintf('%g db is a factor %g attenuation', outDb, outPwr)
end
    