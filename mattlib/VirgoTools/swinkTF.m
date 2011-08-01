function [G,f] = myTransfer(inChan, outChan,  gps0, freqres, navg);
%function [G,f] = myTransfer(inChan, outChan, gps0, freqres, navg);

%default navg = 10, freqres = 1 Hz??

dt_window = 1/freqres;
dt_total = (navg/2 + 0.5) * dt_window; %with overlap
%dt_total = navg * dt_window; %without overlap

disp (['I need roughly ',int2str(dt_total),' seconds of data.'])


[din,tin] = getData(inChan, gps0,1.1*dt_total); %get a little extra
[dout,tout] = getData(outChan, gps0,1.1*dt_total); 

[tout,dout,tin,din] = coerceSignals(tout,dout,tin,din);


fsample = 1/(tin(2)-tin(1));



%round down to power of 2 so actual window is slightly shorter
nfft = 2^floor(log2(dt_window * fsample));
ntotal = (navg+1) * nfft / 2;

dt_window_true = nfft / fsample;
dt_total_true = ntotal / fsample;

fprintf('The true frequency resolution is %g.\n',1/dt_window_true);
fprintf('Nfft = %i, ntotal = %i\n',nfft,ntotal )
fprintf('The time window is %g sec for a total of %g seconds.\n',dt_window_true,dt_total_true);


din = din(1:ntotal);
dout = dout(1:ntotal);

dout=detrend(dout); 
din=detrend(din);


[G,f] = tfestimate(din,dout,hann(nfft),[],[], fsample);



% Favg = zeros(nfft,1);
% 
% win = hann(nfft);
% for i = 0:navg-1
%     istart = i*(nfft/2); %with overlap
%     %istart = i*nfft; %without overlap
% 
%     s1 = dout(istart+1:istart+nfft);
%     s2 = din(istart+1:istart+nfft);
%     Favg = Favg + fft(win.*s1)./fft(win.*s2);
% end
% Favg = Favg / navg;
% 
% %throw away second half
% f = (0:nfft/2 - 1) / dt_window_true;
% Favg = Favg(1:nfft/2);
% G=Favg;

if nargout == 0
    figure;
    ax(1) = subplot(211)
    loglog(f,abs(G));
    ylabel('Amplitude')
    title(['Transfer function of ',outChan,' versus ',inChan,' at gps = ',int2str(gps0)],'interpreter','none');
    ax(2) = subplot(212)
    semilogx(f,angle(G));
    xlabel('Frequency (Hz)')
    ylabel('Phase (rad)')
    linkaxes(ax,'x')

end 


