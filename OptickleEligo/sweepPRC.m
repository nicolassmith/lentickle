% Sweep PRC (power recycling cavity length) in DRFPMI and generate plots.
%
% This displays some DC signals, and some demod signals, during
% a PRC sweep.  From this sweep, one might try to find a good
% signal for PRC.


% prepare some variables
sweepSetupL1

Nsweep = 150;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRC sweep
pos = zeros(opt.Ndrive, 1);
pos(nPR) = 30e-9;
%pos(nSR) = -30e-9;
tic
[xPos, sigDC, fDC] = sweepLinear(opt, -pos, pos, Nsweep);
toc

% make some plots
n = getFieldIn(opt,'PR','fr');
fDCp = abs(squeeze(fDC(n,:,:)));

subplot('position',[0.05 0.48 0.9 0.45])
semilogy(xPos(nPR, :)*1e9,fDCp)
title('PRC sweep: RF fields in the PRC (top) & POX demods (bottom)')
%legend(num2str([vFrf(nSBa); vFrf(nSBb)] / 1e6))
set(gca,'XTickLabel',[])
grid on
axis([-pos(nPR)*1e9 pos(nPR)*1e9 1e-3 2000])

probeNumbers = [nPOX_25_I nPOX_25_Q];
subplot('position',[0.05 0.06 0.9 0.4])
plot(xPos(nPR,:)*1e9, sigDC(probeNumbers,:))
%legend(prbNames(nREFL(2:end)), 'REFL IM + IP')
grid on
axis([-pos(nPR)*1e9 pos(nPR)*1e9 -0.002 0.002])
axis tight
xlabel('PRC motion [nm]')
  
