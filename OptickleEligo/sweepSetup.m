%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script prepares some variables for the sweep functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create the model
cfgH1

% get the serial numbers of some optics
nPR = getDriveIndex(opt, 'PR');
nBS = getDriveIndex(opt, 'BS');
nIX = getDriveIndex(opt, 'IX');
nIY = getDriveIndex(opt, 'IY');
nEX = getDriveIndex(opt, 'EX');
nEY = getDriveIndex(opt, 'EY');
nOMCa = getDriveIndex(opt, 'OMCa');
nOMCb = getDriveIndex(opt, 'OMCb');

% serial #'s for laser noises
nAM = getDriveIndex(opt,'AM');
nPM = getDriveIndex(opt,'PM');

% probe names and numbers
% get some probe indexes
nOMCt = getProbeNum(opt, 'OMCT DC');
nAS_25_Q = getProbeNum(opt, 'AS Q1');
nREFL_61_I = getProbeNum(opt, 'REFL I2');
nPOX_25_I = getProbeNum(opt, 'POX I1');
nPOX_25_Q = getProbeNum(opt, 'POX Q1');


