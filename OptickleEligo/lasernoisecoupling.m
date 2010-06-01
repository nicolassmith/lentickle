% Calculate Laser and Oscillator noise coupling transfer functions
%

% Set up Optickle parameters
sweepSetup

% Frequency grid
f = logspace(0.5,4.5,1000)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RF Readout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dLm = 1e-13;                    % No DARM offset
pos = zeros(opt.Ndrive, 1);
pos(nEX) = dLm / 2;
pos(nEY) = -dLm / 2;

% ==== Optical transfer functions
% hRF and hDC are from mirror position to sensor signal (W/m)
[fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, pos, f);

hX = getTF(sigAC, nAS_25_Q, nEX);
hY = getTF(sigAC, nAS_25_Q, nEY);
hRF = hY - hX;

% intensity noise
hAMRF = getTF(sigAC, nAS_25_Q, nAM);
aAMRF = abs(hAMRF ./ hRF);

% frequency noise (phase noise divided by i*f)
hFreqRF = getTF(sigAC, nAS_25_Q, nPM) ./ (i * f);
aFreqRF = abs(hFreqRF ./ hRF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DC Readout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
offDC = 17e-12;                    % Some DARM offset
pos = zeros(opt.Ndrive, 1);
pos(nEX) = offDC / 2;
pos(nEY) = -offDC / 2;

[fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, pos, f);

hX = getTF(sigAC, nOMCt, nEX);
hY = getTF(sigAC, nOMCt, nEY);
hDC = hY - hX;

% intensity noise
hAMDC = getTF(sigAC, nOMCt, nAM);
aAMDC = abs(hAMDC ./ hDC);

% frequency noise
hFreqDC = getTF(sigAC, nOMCt, nPM) ./ (i * f);
aFreqDC = abs(hFreqDC ./ hDC);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot('Position',[0.09,0.52,0.89,0.43]);
loglog(f, aAMDC, 'b', f, aAMRF, 'r');
title('eLIGO noise couplings for RF (dL- = 1e-13) & DC (dL- = 17e-12)')
legend('AM DC', 'AM RF', 'Location', 'SouthWest')
%xlabel('Hz')
set(gca,'XTickLabel',[])
ylabel('Amplitude Noise Coupling [m/RIN]')
grid on
axis([min(f) max(f) 1e-14 1e-9])

subplot('Position',[0.09,0.06,0.89,0.43]);
loglog(f, aFreqDC, 'b', f, aFreqRF, 'r');
%title('Frequency Noises Coupling')
legend('Freq DC', 'Freq RF', 'Location', 'SouthWest')
xlabel('Hz')
ylabel('Frequency Noise Coupling [m/Hz]')
grid on
axis([min(f) max(f) 1e-15 1e-12])

%orient tall
%print -dpng ln.png


