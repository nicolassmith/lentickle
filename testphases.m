% test phases

mEX = getDriveNum(opt,'EX');
mEY = getDriveNum(opt,'EY');

nASQ = getProbeNum(opt,'AS Q1');
nASI = getProbeNum(opt,'AS I1');

f0 = 150;

[fDC, sigDC, sigAC] = tickle(opt, posOffset, f0);


hx_q = getTF(sigAC,nASQ,mEX);
hy_q = getTF(sigAC,nASQ,mEY);
hx_i = getTF(sigAC,nASI,mEX);
hy_i = getTF(sigAC,nASI,mEY);


h_q = hx_q-hy_q;

h_i = hx_i-hy_i;

disp(num2str(abs(h_q/h_i)))