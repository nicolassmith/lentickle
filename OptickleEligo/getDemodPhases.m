% Measure Sensing Matrix at 1 frequency to set demod phases

sweepSetup

dLm = 10e-12;
dLp = 0;
dlm = 0;
dlp = 0;

pos = zeros(opt.Ndrive, 1);
pos(nEX) =  dLm / 2;
pos(nEY) = -dLm / 2;

% Setup special probes for demod phase measurement
nAS_25_Q = getProbeNum(opt, 'AS Q1');
nAS_25_I = getProbeNum(opt, 'AS I1');
nREFL_25_I = getProbeNum(opt, 'REFL I1');
nREFL_25_Q = getProbeNum(opt, 'REFL Q1');
nREFL_61_I = getProbeNum(opt, 'REFL I2');
nREFL_61_Q = getProbeNum(opt, 'REFL Q2');
nPOX_25_I = getProbeNum(opt, 'POX I1');
nPOX_25_Q = getProbeNum(opt, 'POX Q1');

% compute the DC signals and TFs on resonances
f = 150;
[fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, pos, f);

hX = getTF(sigAC, nAS_25_Q, nEX);
hY = getTF(sigAC, nAS_25_Q, nEY);
hDARMasq = hX - hY;

hX = getTF(sigAC, nAS_25_I, nEX);
hY = getTF(sigAC, nAS_25_I, nEY);
hDARMasi = hX - hY;

as_phase = -1*findBestPhase(hDARMasq,hDARMasi)

hX = getTF(sigAC, nREFL_61_I, nEX);
hY = getTF(sigAC, nREFL_61_I, nEY);
hCARMrefli = hY + hX;

hX = getTF(sigAC, nREFL_61_Q, nEX);
hY = getTF(sigAC, nREFL_61_Q, nEY);
hCARMreflq = hY + hX;

refl_phase = findBestPhase(hCARMrefli,hCARMreflq)

hX = getTF(sigAC, nREFL_25_I, nEX);
hY = getTF(sigAC, nREFL_25_I, nEY);
hCARMrefl1i = hY + hX;

hX = getTF(sigAC, nREFL_25_Q, nEX);
hY = getTF(sigAC, nREFL_25_Q, nEY);
hCARMrefl1q = hY + hX;

refl1_phase = findBestPhase(hCARMrefl1i,hCARMrefl1q)

hPRCpoxi = getTF(sigAC, nPOX_25_I, nPR);
hPRCpoxq = getTF(sigAC, nPOX_25_Q, nPR);

pox_phase = findBestPhase(hPRCpoxi,hPRCpoxq)






