function [Coh,F] = myCoherence(channel1, channel2, gps0, freqres, navg);

%default navg = 10, freqres = 1 Hz??

%tested: gives same result as datadisplay except for some (numerical?)
%noise when using Hann window

dt_window = 1/freqres;
dt_total = (navg/2 + 0.5) * dt_window;

disp (['I need roughly ',int2str(dt_total),' seconds of data.'])

[d1,t1] = getData(channel1, gps0,1.5*dt_total); %get a little extra
[d2,t2] = getData(channel2, gps0,1.5*dt_total); %get a little extra



%[b,a]=butter(4,0.4); %anti-alias filter and downsample
%d1 = filter(b,a,d1);
%d1 = d1(1:2:end);
%t1 = t1(1:2:end);
[t1,d1,t2,d2] = coerceSignals(t1,d1,t2,d2);

fsample = 1/(t1(2)-t1(1));




%round down to power of 2 so actual window is slightly shorter
nfft = 2^floor(log2(dt_window * fsample));
ntotal = (navg+1) * nfft / 2;

dt_window_true = nfft / fsample;
%dt_total_true = round((navg/2 + 0.5) * nfft) / fsample;
dt_total_true = ntotal / fsample;

fprintf('The true frequency resolution is %g.\n',1/dt_window_true);
fprintf('Nfft = %i, ntotal = %i\n',nfft,ntotal )
fprintf('The time window is %g sec for a total of %g seconds.\n',dt_window_true,dt_total_true);



d1 = d1(1:ntotal);
d2 = d2(1:ntotal);

%d1 = detrend(d1);
%d2 = detrend(d2);

[Coh,F] = mscohere(d1,d2,hann(nfft),[],[], fsample);

if nargout == 0
    figure;
    plot(F,Coh)
    xlabel('Frequency (Hz)')
    ylabel('Ampl / sqrt(Hz)')
    title(['Coherence of ',channel1,' versus ',channel2,' at gps = ',int2str(gps0)],'interpreter','none');
end