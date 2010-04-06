
function opt = probeSens(opt, par);

% Add attenuators and terminal sinks
% Here the second return value of the addSink function is used.
% This return value is the serial number of the Sink, which is
% can be used in place of its name for linking (with a marginal
% increase in efficiency).

% Sink argument is power loss, default is 1
% Attenuator set in order to have not more than 10mW on each diode

% AS: transmission to the dark port from BS, before the OMC 
% OMCr: reflection from the OMC
% OMCt: transmission to the OMC


opt = addSink(opt, 'AttREFL', 0.997); %tuned for 35W
opt = addSink(opt, 'AttPOX',  0.9967);
opt = addSink(opt, 'AttPOY',  0.9967);
opt = addSink(opt, 'AttAS',   0.89);  % not tuned yet
opt = addSink(opt, 'AttOMCt',  0); % not tuned yet
opt = addSink(opt, 'AttOMCr',  0); % not tuned yet


opt = addSink(opt, 'REFL');
opt = addSink(opt, 'POX');
opt = addSink(opt, 'POY');
opt = addSink(opt, 'AS');
opt = addSink(opt, 'OMCt');
opt = addSink(opt, 'OMCr');

[opt, nTRX] = addSink(opt, 'TRX');
[opt, nTRY] = addSink(opt, 'TRY');

% Output links, set gouy phases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function addReaduotGouy set the gouy phase 90 degrees apart
% NB: Demodulation phases are in degrees, gouy phases in radiants!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% REFL
opt = addLink(opt, 'PR', 'bk', 'AttREFL', 'in', 5);
[opt, nREFL_A, nREFL_B] = addReadoutGouyAB(opt, 'REFL', par.gouy.REFL_A, par.gouy.REFL_B, 'AttREFL');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POX
opt = addLink(opt, 'IX', 'po', 'AttPOX', 'in', 5);
[opt, nPOX_A, nPOX_B] = addReadoutGouyAB(opt, 'POX', par.gouy.POX_A, par.gouy.POX_B, 'AttPOX');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POY
opt = addLink(opt, 'IY', 'po', 'AttPOY', 'in', 5);
[opt, nPOY_A, nPOY_B] = addReadoutGouy(opt, 'POY', par.gouy.POY, 'AttPOY');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRX and TRY
opt = addLink(opt, 'EX', 'bk', nTRX, 'in', 5);
opt = addLink(opt, 'EY', 'bk', nTRY, 'in', 5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AS Asymmetric port (before the OMC)
opt = addLink(opt, 'ASsplit', 'bk', 'AttAS', 'in', 1);
%[opt, nAS_A, nAS_B] = addReadoutGouy(opt, 'AS', par.gouy.AS, 'AttAS');
[opt, nAS_A, nAS_B] = addReadoutGouyAB(opt, 'AS', par.gouy.AS_A, par.gouy.AS_B, 'AttAS');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reflection from the OMC (OMCr)
opt = addLink(opt, 'OMCa', 'bk', 'AttOMCr', 'in', 5);
[opt, nOMCr_A, nOMCr_B] = addReadoutGouy(opt, 'OMCr', par.gouy.OMCr, 'AttOMCr');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OMC transmission (OMCt)
opt = addLink(opt, 'OMCb', 'bk', 'AttOMCt', 'in', 5);
[opt, nOMCt_A, nOMCt_B] = addReadoutGouy(opt, 'OMCt', par.gouy.OMCt, 'AttOMCt');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add Probes

% double-demod sum (plus) and difference (minus) frequencies
f1 = par.Mod.f1;
f2 = par.Mod.f2;
fp = f2 + f1;
fm = f2 - f1;
f1_2 = 2 * f1;
f2_2 = 2 * f2;

%p = par.phi;

% REFL_A signals (reflected or symmetric port)
% Phase Gouy A
opt = addProbeIn(opt, 'REFL_A DC', nREFL_A, 'in',  0, 0);             % DC
opt = addProbeIn(opt, 'REFL_A I1', nREFL_A, 'in', f1, par.phi.REFL_A1);       % f1 demod I
opt = addProbeIn(opt, 'REFL_A Q1', nREFL_A, 'in', f1, par.phi.REFL_A1 + 90);  % f1 demod Q
opt = addProbeIn(opt, 'REFL_A IM', nREFL_A, 'in', fm, par.phi.REFL_AM);       % fm demod I
opt = addProbeIn(opt, 'REFL_A QM', nREFL_A, 'in', fm, par.phi.REFL_AM + 90);  % fm demod Q
opt = addProbeIn(opt, 'REFL_A IP', nREFL_A, 'in', fp, par.phi.REFL_AP);       % fp demod I
opt = addProbeIn(opt, 'REFL_A QP', nREFL_A, 'in', fp, par.phi.REFL_AP + 90);  % fp demod Q
opt = addProbeIn(opt, 'REFL_A I2', nREFL_A, 'in', f2, par.phi.REFL_A2);       % f2 demod I
opt = addProbeIn(opt, 'REFL_A Q2', nREFL_A, 'in', f2, par.phi.REFL_A2 + 90);  % f2 demod Q
opt = addProbeIn(opt, 'REFL_A I31', nREFL_A, 'in', 3*f1, par.phi.REFL_A31);       % 3*f1 demod I
opt = addProbeIn(opt, 'REFL_A Q31', nREFL_A, 'in', 3*f1, par.phi.REFL_A31 + 90);  % 3*f1 demod Q
opt = addProbeIn(opt, 'REFL_A I32', nREFL_A, 'in', 3*f2, par.phi.REFL_A32);       % 3*f1 demod I
opt = addProbeIn(opt, 'REFL_A Q32', nREFL_A, 'in', 3*f2, par.phi.REFL_A32 + 90);  % 3*f1 demod Q

% Phase Gouy B
opt = addProbeIn(opt, 'REFL_B DC', nREFL_B, 'in',  0, 0);             % DC
opt = addProbeIn(opt, 'REFL_B I1', nREFL_B, 'in', f1, par.phi.REFL_B1);       % f1 demod I
opt = addProbeIn(opt, 'REFL_B Q1', nREFL_B, 'in', f1, par.phi.REFL_B1 + 90);  % f1 demod Q
opt = addProbeIn(opt, 'REFL_B IM', nREFL_B, 'in', fm, par.phi.REFL_BM);       % fm demod I
opt = addProbeIn(opt, 'REFL_B QM', nREFL_B, 'in', fm, par.phi.REFL_BM + 90);  % fm demod Q
opt = addProbeIn(opt, 'REFL_B IP', nREFL_B, 'in', fp, par.phi.REFL_BP);       % fp demod I
opt = addProbeIn(opt, 'REFL_B QP', nREFL_B, 'in', fp, par.phi.REFL_BP + 90);  % fp demod Q
opt = addProbeIn(opt, 'REFL_B I2', nREFL_B, 'in', f2, par.phi.REFL_B2);       % f2 demod I
opt = addProbeIn(opt, 'REFL_B Q2', nREFL_B, 'in', f2, par.phi.REFL_B2 + 90);  % f2 demod Q
opt = addProbeIn(opt, 'REFL_B I31', nREFL_B, 'in', 3*f1, par.phi.REFL_B31);       % 3*f1 demod I
opt = addProbeIn(opt, 'REFL_B Q31', nREFL_B, 'in', 3*f1, par.phi.REFL_B31 + 90);  % 3*f1 demod Q
opt = addProbeIn(opt, 'REFL_B I32', nREFL_B, 'in', 3*f2, par.phi.REFL_B32);       % 3*f1 demod I
opt = addProbeIn(opt, 'REFL_B Q32', nREFL_B, 'in', 3*f2, par.phi.REFL_B32 + 90);  % 3*f1 demod Q

% POX signals (IX pick-off)
opt = addProbeIn(opt, 'POX_A DC', nPOX_A, 'in',  0, 0);		    % DC
opt = addProbeIn(opt, 'POX_A I1', nPOX_A, 'in', f1, par.phi.POX_A1);		% f1 demod I
opt = addProbeIn(opt, 'POX_A Q1', nPOX_A, 'in', f1, par.phi.POX_A1 + 90);	% f1 demod Q
opt = addProbeIn(opt, 'POX_A IM', nPOX_A, 'in', fm, par.phi.POX_AM);		% fm demod I
opt = addProbeIn(opt, 'POX_A QM', nPOX_A, 'in', fm, par.phi.POX_AM + 90);	% fm demod Q
opt = addProbeIn(opt, 'POX_A IP', nPOX_A, 'in', fp, par.phi.POX_AP);		% fp demod I
opt = addProbeIn(opt, 'POX_A QP', nPOX_A, 'in', fp, par.phi.POX_AP + 90);	% fp demod Q
opt = addProbeIn(opt, 'POX_A I2', nPOX_A, 'in', f2, par.phi.POX_A2);		% f1 demod I
opt = addProbeIn(opt, 'POX_A Q2', nPOX_A, 'in', f2, par.phi.POX_A2 + 90);	% f1 demod Q

opt = addProbeIn(opt, 'POX_A I21', nPOX_A, 'in', f1_2, par.phi.POX_A21);	    % 2*f1 demod I
opt = addProbeIn(opt, 'POX_A Q21', nPOX_A, 'in', f1_2, par.phi.POX_A21 + 90);	% 2*f1 demod Q
opt = addProbeIn(opt, 'POX_A I22', nPOX_A, 'in', f2_2, par.phi.POX_A22);	    % 2*f2 demod I
opt = addProbeIn(opt, 'POX_A Q22', nPOX_A, 'in', f2_2, par.phi.POX_A22 + 90);	% 2*f2 demod Q


opt = addProbeIn(opt, 'POX_B DC', nPOX_B, 'in',  0, 0);		    % DC
opt = addProbeIn(opt, 'POX_B I1', nPOX_B, 'in', f1, par.phi.POX_B1);		% f1 demod I
opt = addProbeIn(opt, 'POX_B Q1', nPOX_B, 'in', f1, par.phi.POX_B1 + 90);	% f1 demod Q
opt = addProbeIn(opt, 'POX_B IM', nPOX_B, 'in', fm, par.phi.POX_BM);		% fm demod I
opt = addProbeIn(opt, 'POX_B QM', nPOX_B, 'in', fm, par.phi.POX_BM + 90);	% fm demod Q
opt = addProbeIn(opt, 'POX_B IP', nPOX_B, 'in', fp, par.phi.POX_BP);		% fp demod I
opt = addProbeIn(opt, 'POX_B QP', nPOX_B, 'in', fp, par.phi.POX_BP + 90);	% fp demod Q
opt = addProbeIn(opt, 'POX_B I2', nPOX_B, 'in', f2, par.phi.POX_B2);		% f1 demod I
opt = addProbeIn(opt, 'POX_B Q2', nPOX_B, 'in', f2, par.phi.POX_B2 + 90);	% f1 demod Q

opt = addProbeIn(opt, 'POX_B I21', nPOX_B, 'in', f1_2, par.phi.POX_B21);	    % 2*f1 demod I
opt = addProbeIn(opt, 'POX_B Q21', nPOX_B, 'in', f1_2, par.phi.POX_B21 + 90);	% 2*f1 demod Q
opt = addProbeIn(opt, 'POX_B I22', nPOX_B, 'in', f2_2, par.phi.POX_B22);	    % 2*f2 demod I
opt = addProbeIn(opt, 'POX_B Q22', nPOX_B, 'in', f2_2, par.phi.POX_B22 + 90);	% 2*f2 demod Q


% POY signals (IX pick-off)
opt = addProbeIn(opt, 'POY_A DC', nPOY_A, 'in',  0, 0);		    % DC
opt = addProbeIn(opt, 'POY_A I1', nPOY_A, 'in', f1, par.phi.POY_A1);		% f1 demod I
opt = addProbeIn(opt, 'POY_A Q1', nPOY_A, 'in', f1, par.phi.POY_A1 + 90);	% f1 demod Q
opt = addProbeIn(opt, 'POY_A IM', nPOY_A, 'in', fm, par.phi.POY_AM);		% fm demod I
opt = addProbeIn(opt, 'POY_A QM', nPOY_A, 'in', fm, par.phi.POY_AM + 90);	% fm demod Q
opt = addProbeIn(opt, 'POY_A IP', nPOY_A, 'in', fp, par.phi.POY_AP);		% fp demod I
opt = addProbeIn(opt, 'POY_A QP', nPOY_A, 'in', fp, par.phi.POY_AP + 90);	% fp demod Q
opt = addProbeIn(opt, 'POY_A I2', nPOY_A, 'in', f2, par.phi.POY_A2);		% f1 demod I
opt = addProbeIn(opt, 'POY_A Q2', nPOY_A, 'in', f2, par.phi.POY_A2 + 90);	% f1 demod Q

opt = addProbeIn(opt, 'POY_A I21', nPOY_A, 'in', f1_2, par.phi.POY_A21);	    % 2*f1 demod I
opt = addProbeIn(opt, 'POY_A Q21', nPOY_A, 'in', f1_2, par.phi.POY_A21 + 90);	% 2*f1 demod Q
opt = addProbeIn(opt, 'POY_A I22', nPOY_A, 'in', f2_2, par.phi.POY_A22);	    % 2*f2 demod I
opt = addProbeIn(opt, 'POY_A Q22', nPOY_A, 'in', f2_2, par.phi.POY_A22 + 90);	% 2*f2 demod Q


opt = addProbeIn(opt, 'POY_B DC', nPOY_B, 'in',  0, 0);		    % DC
opt = addProbeIn(opt, 'POY_B I1', nPOY_B, 'in', f1, par.phi.POY_B1);		% f1 demod I
opt = addProbeIn(opt, 'POY_B Q1', nPOY_B, 'in', f1, par.phi.POY_B1 + 90);	% f1 demod Q
opt = addProbeIn(opt, 'POY_B IM', nPOY_B, 'in', fm, par.phi.POY_BM);		% fm demod I
opt = addProbeIn(opt, 'POY_B QM', nPOY_B, 'in', fm, par.phi.POY_BM + 90);	% fm demod Q
opt = addProbeIn(opt, 'POY_B IP', nPOY_B, 'in', fp, par.phi.POY_BP);		% fp demod I
opt = addProbeIn(opt, 'POY_B QP', nPOY_B, 'in', fp, par.phi.POY_BP + 90);	% fp demod Q
opt = addProbeIn(opt, 'POY_B I2', nPOY_B, 'in', f2, par.phi.POY_B2);		% f1 demod I
opt = addProbeIn(opt, 'POY_B Q2', nPOY_B, 'in', f2, par.phi.POY_B2 + 90);	% f1 demod Q

opt = addProbeIn(opt, 'POY_B I21', nPOY_B, 'in', f1_2, par.phi.POY_B21);	    % 2*f1 demod I
opt = addProbeIn(opt, 'POY_B Q21', nPOY_B, 'in', f1_2, par.phi.POY_B21 + 90);	% 2*f1 demod Q
opt = addProbeIn(opt, 'POY_B I22', nPOY_B, 'in', f2_2, par.phi.POY_B22);	    % 2*f2 demod I
opt = addProbeIn(opt, 'POY_B Q22', nPOY_B, 'in', f2_2, par.phi.POY_B22 + 90);	% 2*f2 demod Q


% AS signals (anti-symmetric port)
opt = addProbeIn(opt, 'AS_A DC', nAS_A, 'in',  0, 0);                  % DC
opt = addProbeIn(opt, 'AS_A I1', nAS_A, 'in', f1, par.phi.AS_A1);        % f1 demod I
opt = addProbeIn(opt, 'AS_A Q1', nAS_A, 'in', f1, par.phi.AS_A1 + 90);   % f1 demod Q
opt = addProbeIn(opt, 'AS_A I2', nAS_A, 'in', f2, par.phi.AS_A2);        % f2 demod I
opt = addProbeIn(opt, 'AS_A Q2', nAS_A, 'in', f2, par.phi.AS_A2 + 90);   % f2 demod Q
opt = addProbeIn(opt, 'AS_A IM', nAS_A, 'in', fm, par.phi.AS_AM);        % fm demod I
opt = addProbeIn(opt, 'AS_A QM', nAS_A, 'in', fm, par.phi.AS_AM + 90);   % fm demod Q
opt = addProbeIn(opt, 'AS_A IP', nAS_A, 'in', fp, par.phi.AS_AP);        % fp demod I
opt = addProbeIn(opt, 'AS_A QP', nAS_A, 'in', fp, par.phi.AS_AP + 90);   % fp demod Q
opt = addProbeIn(opt, 'AS_A I21', nAS_A, 'in', fp, par.phi.AS_A21);        % fp demod I
opt = addProbeIn(opt, 'AS_A Q21', nAS_A, 'in', fp, par.phi.AS_A21 + 90);   % fp demod Q
opt = addProbeIn(opt, 'AS_A I22', nAS_A, 'in', fp, par.phi.AS_A22);        % fp demod I
opt = addProbeIn(opt, 'AS_A Q22', nAS_A, 'in', fp, par.phi.AS_A22 + 90);   % fp demod Q


opt = addProbeIn(opt, 'AS_B DC', nAS_B, 'in',  0, 0);                  % DC
opt = addProbeIn(opt, 'AS_B I1', nAS_B, 'in', f1, par.phi.AS_B1);        % f1 demod I
opt = addProbeIn(opt, 'AS_B Q1', nAS_B, 'in', f1, par.phi.AS_B1 + 90);   % f1 demod Q
opt = addProbeIn(opt, 'AS_B I2', nAS_B, 'in', f2, par.phi.AS_B2);        % f2 demod I
opt = addProbeIn(opt, 'AS_B Q2', nAS_B, 'in', f2, par.phi.AS_B2 + 90);   % f2 demod Q
opt = addProbeIn(opt, 'AS_B IM', nAS_B, 'in', fm, par.phi.AS_BM);        % fm demod I
opt = addProbeIn(opt, 'AS_B QM', nAS_B, 'in', fm, par.phi.AS_BM + 90);   % fm demod Q
opt = addProbeIn(opt, 'AS_B IP', nAS_B, 'in', fp, par.phi.AS_BP);        % fp demod I
opt = addProbeIn(opt, 'AS_B QP', nAS_B, 'in', fp, par.phi.AS_BP + 90);   % fp demod Q
opt = addProbeIn(opt, 'AS_B I21', nAS_B, 'in', fp, par.phi.AS_B21);        % fp demod I
opt = addProbeIn(opt, 'AS_B Q21', nAS_B, 'in', fp, par.phi.AS_B21 + 90);   % fp demod Q
opt = addProbeIn(opt, 'AS_B I22', nAS_B, 'in', fp, par.phi.AS_B22);        % fp demod I
opt = addProbeIn(opt, 'AS_B Q22', nAS_B, 'in', fp, par.phi.AS_B22 + 90);   % fp demod Q


% OMC reflected signals
opt = addProbeIn(opt, 'OMCr_A DC', nOMCr_A, 'in',  0,  0);          % DC
opt = addProbeIn(opt, 'OMCr_A I1', nOMCr_A, 'in', f1, par.phi.OMCr_A1);        % f1 demod I
opt = addProbeIn(opt, 'OMCr_A Q1', nOMCr_A, 'in', f1, par.phi.OMCr_A1 + 90);   % f1 demod Q
opt = addProbeIn(opt, 'OMCr_A IM', nOMCr_A, 'in', fm, par.phi.OMCr_AM);		% fm demod I
opt = addProbeIn(opt, 'OMCr_A QM', nOMCr_A, 'in', fm, par.phi.OMCr_AM + 90);   % fm demod Q
opt = addProbeIn(opt, 'OMCr_A IP', nOMCr_A, 'in', fp, par.phi.OMCr_AP);		% fp demod I
opt = addProbeIn(opt, 'OMCr_A QP', nOMCr_A, 'in', fp, par.phi.OMCr_AP + 90);	% fp demod Q
opt = addProbeIn(opt, 'OMCr_A I2', nOMCr_A, 'in', f2, par.phi.OMCr_A2 );       % f2 demod Q
opt = addProbeIn(opt, 'OMCr_A Q2', nOMCr_A, 'in', f2, par.phi.OMCr_A2 + 90);   % f2 demod Q

opt = addProbeIn(opt, 'OMCr_B DC', nOMCr_B, 'in',  0,  0);              % DC
opt = addProbeIn(opt, 'OMCr_B I1', nOMCr_B, 'in', f1, par.phi.OMCr_B1);        % f1 demod I
opt = addProbeIn(opt, 'OMCr_B Q1', nOMCr_B, 'in', f1, par.phi.OMCr_B1 + 90);   % f1 demod Q
opt = addProbeIn(opt, 'OMCr_B IM', nOMCr_B, 'in', fm, par.phi.OMCr_BM);		% fm demod I
opt = addProbeIn(opt, 'OMCr_B QM', nOMCr_B, 'in', fm, par.phi.OMCr_BM + 90);   % fm demod Q
opt = addProbeIn(opt, 'OMCr_B IP', nOMCr_B, 'in', fp, par.phi.OMCr_BP);		% fp demod I
opt = addProbeIn(opt, 'OMCr_B QP', nOMCr_B, 'in', fp, par.phi.OMCr_BP + 90);	% fp demod Q
opt = addProbeIn(opt, 'OMCr_B I2', nOMCr_B, 'in', f2, par.phi.OMCr_B2);        % f2 demod Q
opt = addProbeIn(opt, 'OMCr_B Q2', nOMCr_B, 'in', f2, par.phi.OMCr_B2 + 90);   % f2 demod Q


% OMC transmitted signals
opt = addProbeIn(opt, 'OMCt_A DC', nOMCt_A, 'in',  0,  0);          % DC
opt = addProbeIn(opt, 'OMCt_A I1', nOMCt_A, 'in', f1, par.phi.OMCt_A1);        % f1 demod I
opt = addProbeIn(opt, 'OMCt_A Q1', nOMCt_A, 'in', f1, par.phi.OMCt_A1 + 90);   % f1 demod Q
opt = addProbeIn(opt, 'OMCt_A IM', nOMCt_A, 'in', fm, par.phi.OMCt_AM);		% fm demod I
opt = addProbeIn(opt, 'OMCt_A QM', nOMCt_A, 'in', fm, par.phi.OMCt_AM + 90);   % fm demod Q
opt = addProbeIn(opt, 'OMCt_A IP', nOMCt_A, 'in', fp, par.phi.OMCt_AP);		% fp demod I
opt = addProbeIn(opt, 'OMCt_A QP', nOMCt_A, 'in', fp, par.phi.OMCt_AP + 90);	% fp demod Q
opt = addProbeIn(opt, 'OMCt_A I2', nOMCt_A, 'in', f2, par.phi.OMCt_A2 );       % f2 demod Q
opt = addProbeIn(opt, 'OMCt_A Q2', nOMCt_A, 'in', f2, par.phi.OMCt_A2 + 90);   % f2 demod Q

opt = addProbeIn(opt, 'OMCt_B DC', nOMCt_B, 'in',  0,  0);              % DC
opt = addProbeIn(opt, 'OMCt_B I1', nOMCt_B, 'in', f1, par.phi.OMCt_B1);        % f1 demod I
opt = addProbeIn(opt, 'OMCt_B Q1', nOMCt_B, 'in', f1, par.phi.OMCt_B1 + 90);   % f1 demod Q
opt = addProbeIn(opt, 'OMCt_B IM', nOMCt_B, 'in', fm, par.phi.OMCt_BM);		% fm demod I
opt = addProbeIn(opt, 'OMCt_B QM', nOMCt_B, 'in', fm, par.phi.OMCt_BM + 90);   % fm demod Q
opt = addProbeIn(opt, 'OMCt_B IP', nOMCt_B, 'in', fp, par.phi.OMCt_BP);		% fp demod I
opt = addProbeIn(opt, 'OMCt_B QP', nOMCt_B, 'in', fp, par.phi.OMCt_BP + 90);	% fp demod Q
opt = addProbeIn(opt, 'OMCt_B I2', nOMCt_B, 'in', f2, par.phi.OMCt_B2);        % f2 demod Q
opt = addProbeIn(opt, 'OMCt_B Q2', nOMCt_B, 'in', f2, par.phi.OMCt_B2 + 90);   % f2 demod Q

% Transmitted DC signals
opt = addProbeIn(opt, 'TRX DC', nTRX, 'in', 0, 0);            % DC
opt = addProbeIn(opt, 'TRY DC', nTRY', 'in', 0, 0);            % DC


% add unphysical intra-cavity probes
opt = addProbeIn(opt, 'IX_DC', 'IX', 'fr', 0, 0);
opt = addProbeIn(opt, 'EX_DC', 'EX', 'fr', 0, 0);
opt = addProbeIn(opt, 'IY_DC', 'IY', 'fr', 0, 0);
opt = addProbeIn(opt, 'EY_DC', 'EY', 'fr', 0, 0);
opt = addProbeIn(opt, 'PR_DC', 'PR', 'fr', 0, 0);
opt = addProbeIn(opt, 'BS_DC', 'BS', 'frA', 0, 0);


