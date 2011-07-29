% rms = ampSpectrumRMS(freq, noiseAmp)
%
% freq = frequency vector (N x 1)
% noiseAmp = noise amplitude spectrum (N x M)
%
% rms = cumulative RMS starting at high frequency (N x M)

function rms = ampSpectrumRMS_Lisa(f, noiseAmp)

  rms = ampSpectrumRMS(f, noiseAmp).';
end
