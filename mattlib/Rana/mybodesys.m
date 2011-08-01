function G=mybodesys(sys,f)
%G=mybodesys(sys,f)
%G is the complex transfer function for sys
%evaluated at the frequency vector f in Hz
%if called without left hand argument, 
%it makes a Bode plot of sys 

w=2*pi*f;
[Gm,Gp]=bode(sys,w);
Gm=squeeze(Gm);
Gp=squeeze(Gp);
G=Gm.*exp(i*Gp*pi/180);

if nargout==0
 clf
 subplot(211)
 semilogx(f,20*log10(Gm))
 ylabel('mag (dB)')
 axis([min(f) max(f) floor(min(log10(Gm)))*20 ceil(max(log10(Gm)))*20])
 grid on

 subplot(212)
 semilogx(f,Gp)
 ylabel('phase (deg)')
 xlabel('freq (Hz)')
 axis([min(f) max(f) 90*floor(min(Gp)/90) 90*ceil(max(Gp)/90)])
 set(gca,'YTick',[-1800:90:1800])
 grid on
 
 subplot

 G=[];

end;

