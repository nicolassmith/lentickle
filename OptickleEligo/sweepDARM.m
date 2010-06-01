% Sweep DARM (differential arm length) and generate plots.

sweepSetupL1

dLm = 17e-12;
dLp = 0;
dlm = 0;
dlp = 0;

pos = zeros(opt.Ndrive, 1);
pos(nEX) = dLm / 2;
pos(nEY) = -dLm / 2;


% compute the DC signals and TFs on resonances
f = logspace(-1, 3.5, 100)';
[fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, pos, f);

hX = getTF(sigAC, nAS_25_Q, nEX);
hY = getTF(sigAC, nAS_25_Q, nEY);
hDARMrf = hY - hX;

hX = getTF(sigAC, nOMCt, nEX);
hY = getTF(sigAC, nOMCt, nEY);
hDARM = hY - hX;

hCARM2ASQ = hY + hX;

hPRC2ASQ = getTF(sigAC, nAS_25_Q, nPR);

hPR = getTF(sigAC, nAS_25_Q, nPR);
hBS = getTF(sigAC, nAS_25_Q, nBS);
hMICH2ASQ = hPR + hBS*sqrt(2);


mybodeplot2(f,[hDARM hDARMrf hCARM2ASQ hMICH2ASQ hPRC2ASQ])
ylabel('Mag [dB W/m]')
legend('DARM -> AS\_Q',...
       'DARM -> DC',...
       'CARM -> ASQ',...
       'MICH -> ASQ',...
       'PRC -> ASQ',...
       'Location','NorthWest')
title(['Couplings to AS\_Q with a ' num2str(dLm*1e12) ' pm offset']) 



