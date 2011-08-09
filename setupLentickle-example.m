% sets up environment for lentickle
% edit the paths for your system and save the file as 'setupLentickle.m'

% set up path

OpticklePath =  '~/ligo/sim/Optickle'; % edit these lines for your system
lenticklePath = '~/ligo/sim/lentickle';

% no need to change lines below here
addpath(OpticklePath);
addpath([OpticklePath '/lib'])
addpath(lenticklePath);
addpath([lenticklePath '/mf']);


