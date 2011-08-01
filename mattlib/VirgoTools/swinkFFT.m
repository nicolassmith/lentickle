function [Ampl,F] = myFFT(chanName, gps0, freqres, navg);
%function [Ampl,f] = myFFT(chanName, gps0, freqres, navg);

%default navg = 10, freqres = 1 Hz??

%tested: with Hann window, result is exactly equal to result by datadisplay
%with only some (numerical?) small differences
%only first and last sample seem to be different, does not really depend on
%detrending

dt_window = 1/freqres;
dt_total = (navg/2 + 0.5) * dt_window;

disp (['I need roughly ',int2str(dt_total),' seconds of data.'])

[d,t] = getData(chanName, gps0,1.5*dt_total); %get a little extra

fsample = 1/(t(2)-t(1));

%round down to power of 2 so actual window is slightly shorter
nfft = 2^floor(log2(dt_window * fsample));
ntotal = (navg+1) * nfft / 2;

dt_window_true = nfft / fsample;
dt_total_true = ntotal / fsample;

fprintf('The true frequency resolution is %g.\n',1/dt_window_true);
fprintf('Nfft = %i, ntotal = %i\n',nfft,ntotal )
fprintf('The time window is %g sec for a total of %g seconds.\n',dt_window_true,dt_total_true);

d=d(1:ntotal);
d=detrend(d);

[Power,F] = pwelch(d,hann(nfft),[],[], fsample);

Ampl = sqrt(Power);

if nargout == 0
    figure;
    loglog(F(3:end),Ampl(3:end))
    xlabel('Frequency (Hz)')
    ylabel('Ampl / sqrt(Hz)')
    title(['FFT of ',chanName,' at gps = ',int2str(gps0)],'interpreter','none');
end
