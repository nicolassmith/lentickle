%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set-Up for Recycling ITF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Get the serial numbers of probes

nREFLA_DC  = getProbeNum(opt, 'REFL_A DC');
nREFLA_I   = getProbeNum(opt, 'REFL_A I1');
nREFLA_Q   = getProbeNum(opt, 'REFL_A Q1');

nREFLA_IM  = getProbeNum(opt, 'REFL_A IM');
nREFLA_QM  = getProbeNum(opt, 'REFL_A QM');
nREFLA_IP  = getProbeNum(opt, 'REFL_A IP');
nREFLA_QP  = getProbeNum(opt, 'REFL_A QP');
nREFLA_I2  = getProbeNum(opt, 'REFL_A I2');
nREFLA_Q2  = getProbeNum(opt, 'REFL_A Q2');
nREFLA_31I = getProbeNum(opt, 'REFL_A I31');
nREFLA_31Q = getProbeNum(opt, 'REFL_A Q31');
nREFLA_32I = getProbeNum(opt, 'REFL_A I32');
nREFLA_32Q = getProbeNum(opt, 'REFL_A Q32');

nREFLB_DC = getProbeNum(opt, 'REFL_B DC');
nREFLB_I  = getProbeNum(opt, 'REFL_B I1');
nREFLB_Q  = getProbeNum(opt, 'REFL_B Q1');

nREFLB_IM  = getProbeNum(opt, 'REFL_B IM');
nREFLB_QM  = getProbeNum(opt, 'REFL_B QM');
nREFLB_IP  = getProbeNum(opt, 'REFL_B IP');
nREFLB_QP  = getProbeNum(opt, 'REFL_B QP');
nREFLB_I2  = getProbeNum(opt, 'REFL_B I2');
nREFLB_Q2  = getProbeNum(opt, 'REFL_B Q2');
nREFLB_31I = getProbeNum(opt, 'REFL_B I31');
nREFLB_31Q = getProbeNum(opt, 'REFL_B Q31');
nREFLB_32I = getProbeNum(opt, 'REFL_B I32');
nREFLB_32Q = getProbeNum(opt, 'REFL_B Q32');

nPOXA_DC  = getProbeNum(opt, 'POX_A DC');
nPOXA_I1  = getProbeNum(opt, 'POX_A I1');
nPOXA_Q1  = getProbeNum(opt, 'POX_A Q1');
nPOXA_IM  = getProbeNum(opt, 'POX_A IM');
nPOXA_QM  = getProbeNum(opt, 'POX_A QM');
nPOXA_IP  = getProbeNum(opt, 'POX_A IP');
nPOXA_QP  = getProbeNum(opt, 'POX_A QP');
nPOXA_I2  = getProbeNum(opt, 'POX_A I2');
nPOXA_Q2  = getProbeNum(opt, 'POX_A Q2');
nPOXA_21I = getProbeNum(opt, 'POX_A I21');
nPOXA_21Q = getProbeNum(opt, 'POX_A Q21');
nPOXA_22I = getProbeNum(opt, 'POX_A I22');
nPOXA_22Q = getProbeNum(opt, 'POX_A Q22');

nPOXB_DC  = getProbeNum(opt, 'POX_B DC');
nPOXB_I1  = getProbeNum(opt, 'POX_B I1');
nPOXB_Q1  = getProbeNum(opt, 'POX_B Q1');
nPOXB_IM  = getProbeNum(opt, 'POX_B IM');
nPOXB_QM  = getProbeNum(opt, 'POX_B QM');
nPOXB_IP  = getProbeNum(opt, 'POX_B IP');
nPOXB_QP  = getProbeNum(opt, 'POX_B QP');
nPOXB_I2  = getProbeNum(opt, 'POX_B I2');
nPOXB_Q2  = getProbeNum(opt, 'POX_B Q2');
nPOXB_21I = getProbeNum(opt, 'POX_B I21');
nPOXB_21Q = getProbeNum(opt, 'POX_B Q21');
nPOXB_22I = getProbeNum(opt, 'POX_B I22');
nPOXB_22Q = getProbeNum(opt, 'POX_B Q22');

nASA_DC  = getProbeNum(opt, 'AS_A DC');
nASA_I1  = getProbeNum(opt, 'AS_A I1');
nASA_Q1  = getProbeNum(opt, 'AS_A Q1');
nASA_IM = getProbeNum(opt, 'AS_A IM');
nASA_QM = getProbeNum(opt, 'AS_A QM');
nASA_IP = getProbeNum(opt, 'AS_A IP');
nASA_I2  = getProbeNum(opt, 'AS_A I2');
nASA_Q2  = getProbeNum(opt, 'AS_A Q2');
nASA_QP = getProbeNum(opt, 'AS_A QP');
nASA_21I = getProbeNum(opt, 'AS_A I21');
nASA_21Q = getProbeNum(opt, 'AS_A Q21');
nASA_22I = getProbeNum(opt, 'AS_A I22');
nASA_22Q = getProbeNum(opt, 'AS_A Q22');

nASB_DC  = getProbeNum(opt, 'AS_B DC');
nASB_I1  = getProbeNum(opt, 'AS_B I1');
nASB_Q1  = getProbeNum(opt, 'AS_B Q1');
nASB_IM = getProbeNum(opt, 'AS_B IM');
nASB_QM = getProbeNum(opt, 'AS_B QM');
nASB_IP = getProbeNum(opt, 'AS_B IP');
nASB_I2  = getProbeNum(opt, 'AS_B I2');
nASB_Q2  = getProbeNum(opt, 'AS_B Q2');
nASB_QP = getProbeNum(opt, 'AS_A QP');
nASB_21I = getProbeNum(opt, 'AS_B I21');
nASB_21Q = getProbeNum(opt, 'AS_B Q21');
nASB_22I = getProbeNum(opt, 'AS_B I22');
nASB_22Q = getProbeNum(opt, 'AS_B Q22');


nOMCrA_DC = getProbeNum(opt, 'OMCr_A DC');
nOMCrA_I1 = getProbeNum(opt, 'OMCr_A I1');
nOMCrA_Q1 = getProbeNum(opt, 'OMCr_A Q1');
nOMCrA_IM = getProbeNum(opt, 'OMCr_A IM');
nOMCrA_QM = getProbeNum(opt, 'OMCr_A QM');
nOMCrA_IP = getProbeNum(opt, 'OMCr_A IP');
nOMCrA_QP = getProbeNum(opt, 'OMCr_A QP');
nOMCrA_I2 = getProbeNum(opt, 'OMCr_A I2');
nOMCrA_Q2 = getProbeNum(opt, 'OMCr_A Q2');

nOMCtB_DC = getProbeNum(opt, 'OMCt_B DC');
nOMCtB_I1 = getProbeNum(opt, 'OMCt_B I1');
nOMCtB_Q1 = getProbeNum(opt, 'OMCt_B Q1');
nOMCtB_IM = getProbeNum(opt, 'OMCt_B IM');
nOMCtB_QM = getProbeNum(opt, 'OMCt_B QM');
nOMCtB_IP = getProbeNum(opt, 'OMCt_B IP');
nOMCtB_QP = getProbeNum(opt, 'OMCt_B QP');
nOMCtB_I2 = getProbeNum(opt, 'OMCt_B I2');
nOMCtB_Q2 = getProbeNum(opt, 'OMCt_B Q2');


nTRX_DC = getProbeNum(opt, 'TRX DC');
nTRY_DC = getProbeNum(opt, 'TRY DC');


%colors = mkclrmap(15);

colors = [0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  1.0   0.9   0.3;
  0.7   0.9   0.24;
  0.8   0.8   0.8;
  0.1   0.1   0.6;
  0.95  0.23  0.61;
  0.7   0.7   0.2;
  0.4   0.0   0.1
  0.6   0.2   0.1;
  0.6   0.6   0.6;
  0.0   0.2   1.0;
  0.6   0.0   0.7;
  0.0   1.0   0.0;
  0.0   0.0   0.0];


colors1 = [0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;];

colors10 = [0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;];


colors2 = [0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  1.0   0.9   0.3;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  0      0     0;
  0.2   1     0.2;];


colors3 = [0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;];
  


colors4 = [0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;
  0.0   0.0   1.0;
  1.0   0.0   0.0;
  0.0   0.7   0.0;
  0.6   0.4   0.3;
  1     0.3   0.9;];
  
  
set(0,'DefaultAxesColorOrder',colors)
set(0,'DefaultTextColor','black')
set(0,'DefaultTextFontSize',25)
set(0,'DefaultAxesFontSize',16)
set(0,'DefaultLineLineWidth',2)
clear i


