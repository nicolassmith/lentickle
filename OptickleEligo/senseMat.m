% Sweep lengths and generate plots.

sweepSetupL1


dLm = 10e-12;
dLp = 0;
dlm = 0;
dlp = 0;

pos = zeros(opt.Ndrive, 1);
pos(nEX) = dLm / 2;
pos(nEY) = -dLm / 2;


% compute the DC signals and TFs on resonances
f = logspace(-1, 5, 550)';
[fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, pos, f);

hX = getTF(sigAC, nAS_25_Q, nEX);
hY = getTF(sigAC, nAS_25_Q, nEY);
hDARMrf = (hY - hX)/2;

hX = getTF(sigAC, nOMCt, nEX);
hY = getTF(sigAC, nOMCt, nEY);
hDARM = (hY - hX)/2;

hX = getTF(sigAC, nREFL_61_I, nEX);
hY = getTF(sigAC, nREFL_61_I, nEY);
hPM = getTF(sigAC, nREFL_61_I, nPM);
hCARM = hY + hX;
hFM = hPM ./ (i*f) * (opt.c / opt.lambda / 3995);  % FM in units of arm-meters

hPRC = getTF(sigAC, nPOX_25_I, nPR);

hPR = getTF(sigAC, nPOX_25_Q, nPR);
hBS = getTF(sigAC, nPOX_25_Q, nBS);
hMICH = (hPR - hBS*sqrt(2))/2;


hPRC2ASQ = getTF(sigAC, nAS_25_Q, nPR);

hPR = getTF(sigAC, nAS_25_Q, nPR);
hBS = getTF(sigAC, nAS_25_Q, nBS);
hMICH2ASQ = (hPR - hBS*sqrt(2))/2;

mybodeplot2(f,[hDARM hDARMrf hMICH hPRC hFM hMICH2ASQ hPRC2ASQ])
ylabel('Mag [dB W/m]')
title('mLIGO Sensing Matrix with L- offset')
legend('DARM -> DC',...
       'DARM -> AS\_Q',...
       'MICH -> POX\_Q',...
       'PRC -> POX\_I',...
       'FM -> REFL61\_I',...
       'MICH -> AS\_Q',...
       'PRC -> AS\_Q',...
       'Location','NorthWest')




