function opt = probesEligo_00(opt, par)

% Add attenuators and terminal sinks
% Here the second return value of the addSink function is used.
% This return value is the serial number of the Sink, which is
% can be used in place of its name for linking (with a marginal
% increase in efficiency).

% 3rd addSink argument is power loss, default is 1
% Attenuator set to match what is there in the real IFOs, maybe.

% AS: transmission to the dark port from BS, before the OMC 
% OMCr: reflection from the OMC
% OMCt: transmission to the OMC


opt = addSink(opt, 'AttREFL', 0.95);
opt = addSink(opt, 'AttPOX',  0.0);
opt = addSink(opt, 'AttPOY',  0.965);
opt = addSink(opt, 'AttAS',   0);  % not tuned yet
opt = addSink(opt, 'AttOMCt',  0); % not tuned yet
opt = addSink(opt, 'AttOMCr',  0.99); % not tuned yet


[opt, nREFL] = addSink(opt, 'REFL');
[opt, nPOX] = addSink(opt, 'POX');
[opt, nPOY] = addSink(opt, 'POY');
[opt, nAS] = addSink(opt, 'AS');
[opt, nOMCT] = addSink(opt, 'OMCT');
[opt, nOMCR] = addSink(opt, 'OMCR');
[opt, nTRX] = addSink(opt, 'TRX');
[opt, nTRY] = addSink(opt, 'TRY');

% Output links, set gouy phases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function addReaduotGouy set the gouy phase 90 degrees apart
% NB: Demodulation phases are in degrees, gouy phases in radiants!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% REFL
opt = addLink(opt, 'PR', 'bk', 'AttREFL', 'in', 5);
opt = addLink(opt, 'AttREFL', 'out', 'REFL', 'in', 0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POX
opt = addLink(opt, 'IX', 'po', 'AttPOX', 'in', 5);
opt = addLink(opt, 'AttPOX', 'out', 'POX', 'in', 0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POY
opt = addLink(opt, 'IY', 'po', 'AttPOY', 'in', 5);
opt = addLink(opt, 'AttPOY', 'out', 'POY', 'in', 0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRX and TRY
opt = addLink(opt, 'EX', 'bk', 'TRX', 'in', 5);
opt = addLink(opt, 'EY', 'bk', 'TRY', 'in', 5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AS Asymmetric port (before the OMC)
opt = addLink(opt, 'ASsplit', 'bk', 'AttAS', 'in', 1);
opt = addLink(opt, 'AttAS', 'out', 'AS', 'in', 0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reflection from the OMC (OMCR)
opt = addLink(opt, 'OMCa', 'bk', 'AttOMCr', 'in', 5);
opt = addLink(opt, 'AttOMCr', 'out', 'OMCR', 'in', 0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OMC transmission (OMCT)
opt = addLink(opt, 'OMCb', 'bk', 'AttOMCt', 'in', 0.1);
opt = addLink(opt, 'AttOMCt', 'out', 'OMCT', 'in', 0.1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add Probes

% double-demod sum (plus) and difference (minus) frequencies
f1 = par.Mod.f1;
f2 = par.Mod.f2;
f1_2 = 2 * f1;
f2_2 = 2 * f2;

% REFL signals (reflected or symmetric port)
opt = addProbeIn(opt, 'REFL DC', nREFL, 'in',  0, 0);             % DC
opt = addProbeIn(opt, 'REFL I1', nREFL, 'in', f1, par.phi.phREFL1);       % f1 demod I
opt = addProbeIn(opt, 'REFL Q1', nREFL, 'in', f1, par.phi.phREFL1 + 90);  % f1 demod Q
opt = addProbeIn(opt, 'REFL I2', nREFL, 'in', f2, par.phi.phREFL2);       % f2 demod I
opt = addProbeIn(opt, 'REFL Q2', nREFL, 'in', f2, par.phi.phREFL2 + 90);  % f2 demod Q


% POX signals (IX pick-off)
opt = addProbeIn(opt, 'POX DC', nPOX, 'in',  0, 0);		    % DC
opt = addProbeIn(opt, 'POX I1', nPOX, 'in', f1, par.phi.phPOX1);		% f1 demod I
opt = addProbeIn(opt, 'POX Q1', nPOX, 'in', f1, par.phi.phPOX1 + 90);	% f1 demod Q

% POX / SPOX stuff
%opt = addProbeIn(opt, 'POX I21', nPOX, 'in', f1_2, par.phi.POX_21);	    % 2*f1 demod I
%opt = addProbeIn(opt, 'POX Q21', nPOX, 'in', f1_2, par.phi.POX_21 + 90);	% 2*f1 demod Q
%opt = addProbeIn(opt, 'POX I22', nPOX, 'in', f2_2, par.phi.POX_22);	    % 2*f2 demod I
%opt = addProbeIn(opt, 'POX Q22', nPOX, 'in', f2_2, par.phi.POX_22 + 90);	% 2*f2 demod Q


% POY signals (IY pick-off)
%opt = addProbeIn(opt, 'POY DC', nPOY, 'in',  0, 0);		    % DC
%opt = addProbeIn(opt, 'POY I1', nPOY, 'in', f1, par.phi.phPOY1);		% f1 demod I
%opt = addProbeIn(opt, 'POY Q1', nPOY, 'in', f1, par.phi.phPOY1 + 90);	% f1 demod Q


% AS signals (anti-symmetric port before the OMC) 
opt = addProbeIn(opt, 'AS DC', nAS, 'in',  0, 0);                  % DC
opt = addProbeIn(opt, 'AS I1', nAS, 'in', f1, par.phi.phAS1);        % f1 demod I
opt = addProbeIn(opt, 'AS Q1', nAS, 'in', f1, par.phi.phAS1 + 90);   % f1 demod Q
opt = addProbeIn(opt, 'AS I2', nAS, 'in', f2, par.phi.phAS2);        % f2 demod I
opt = addProbeIn(opt, 'AS Q2', nAS, 'in', f2, par.phi.phAS2 + 90);   % f2 demod Q


% OMC reflected signals
opt = addProbeIn(opt, 'OMCR DC', nOMCR, 'in',  0,  0);          % DC
opt = addProbeIn(opt, 'OMCR I1', nOMCR, 'in', f1, par.phi.phOMCR1);        % f1 demod I
opt = addProbeIn(opt, 'OMCR Q1', nOMCR, 'in', f1, par.phi.phOMCR1 + 90);   % f1 demod Q


% OMC transmitted signals
opt = addProbeIn(opt, 'OMCT DC', nOMCT, 'in',  0,  0);          % DC
opt = addProbeIn(opt, 'OMCT I1', nOMCT, 'in', f1, par.phi.phOMCT1);        % f1 demod I
opt = addProbeIn(opt, 'OMCT Q1', nOMCT, 'in', f1, par.phi.phOMCT1 + 90);   % f1 demod Q


% Arm Transmitted DC signals
opt = addProbeIn(opt, 'TRX DC', nTRX, 'in', 0, 0);            % DC
opt = addProbeIn(opt, 'TRY DC', nTRY', 'in', 0, 0);           % DC
