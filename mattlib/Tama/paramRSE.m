% Default RSE parameters
%
% p = paramRSE

function p = paramRSE

  % Input Parameters
  p.lambda = 1064e-9;  % input carrier wave length
 
  % Mirror Paramters
  p.Rpr = 0.76;
  p.Tpr = 0.24;
  p.Rsr = 0.68;
  p.Tsr = 0.32;
  p.Rii = 0.95;
  p.Tii = 0.05;
  p.Rip = 0.95;
  p.Tip = 0.05;
  p.Rei = 0.9999;
  p.Tei = 1e-4;
  p.Rep = 0.9999;
  p.Tep = 1e-4;
  p.Rbs = 0.5;
  p.Tbs = 0.5;
 
  % Pick-Off Losses
  p.Lpoi = 0.01;
  p.Lpop = 0.01;
  
  % Macroscopic Distances (in meters)
  p.Dprbs = 1.94;
  p.Dsrbs = 1.94;
  p.Dbsii = 0.47;
  p.Dbsip = 4.82;
  p.Diiei = 4.15;
  p.Dipep = 4.15;
 
  % Microscopic Distances (in units of lambda)
  p.dpr = 0;
  p.dsr = 1 / 4;
  p.dbs = 0;
  p.dii = 0;
  p.dip = 0;
  p.dei = 0;
  p.dep = 0;
