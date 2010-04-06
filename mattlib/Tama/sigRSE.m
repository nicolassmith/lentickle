% Compute RSE Signals
% (see also fieldRSE and paramRSE)
%
% [sr, si, sp, sd] = sigRSE(p, modType, fMod, gMod, phiDemod, z)
%
% p = parameter struct (see paramRSE)
% modType = 0 means amplitude-modulation, otherwise this sets the
%           phase-modulation expansion order (2 is usually good)
% fMod = modulation/demodulation frequency
% gMod = modulation depth (Mach-Zender is assumed)
% phiDemod = demodulation phases (in degrees)
% z = mirror positions (Nx7)
%
% sr - demod signals (real part)
% si - demod signals (imag part)
% sp - power signals
% sd - demod signals (complex)
%
%% Example:
%
%% Use Default Input Parameters
% p = paramRSE;
%
%% Make mirror positions.  Column order is:
%%  1 = PR, 2 = SE, 3 = BS, 4 = Ii, 5 = Ei, 6 = Ip, 7 = Ep
% z = zeros(201, 7);               % start with all positions zero
% zsw = (-100:100)'/1e8;           % make a sweep
% z(:, 2) = zsw;                   % sweep signal extraction mirror
%
%% Compute Phase-Modulation Signals
% fPM = 17.25e6;                   % modulation frequency
% gPM = 0.1;                       % modulation depth
% phiPM = zeros(15, 1);            % demod phases... start with zeros
% phiPM(14) = 32;                  % set AP (E14) demod phase
%
% [sr, si, sp] = sigRSE(p, 2, fPM, gPM, phiPM, z);
% 
%% Plot demod signals at POI (E6) and AP (E14)
% plot(zsw, [sr(:, 6), si(:, 6), sr(:, 14), si(:, 14)])
% legend('POI real', 'POI imag', 'AP real', 'AP imag')
%
%% Compute Amplitude-Modulation Signals
% fAM = 103.5e6;                   % modulation frequency
% gAM = 0.1;                       % modulation depth
% phiAM = zeros(15, 1);            % demod phases... start with zeros
% phiAM(2) = -21;                  % set SP (E2) demod phase
%
% [sr, si, sp] = sigRSE(p, 0, fAM, gAM, phiAM, z);

function [sr, si, sp, sd] = sigRSE(p, modType, fMod, gMod, phiDemod, z)

  % fixed paramters
  order = 2;                          % sideband expansion order
  ndemod = 1;                         % fdemod / fmod (can be 1, 2, ... up to 2 * order)
  
  % fields to compute
  if modType > 0
    vo = -order:order;
    fIn = fMod * vo;			              % sideband frequencies
    aIn = besselj(vo, gMod) / sqrt(2); 	% sideband amplitudes (with MZ)
    aIn(order + 1) = besselj(0, gMod);  % carrier amplitude
  else
    vo = -1:1;
    fIn = fMod * vo;			              % sideband frequencies
    aIn([1, 3]) = gMod / sqrt(2); 	    % sideband amplitudes (with MZ)
    aIn(2) = 1 - gMod.^2;               % carrier amplitude
  end

  % numbers of things
  Nf = length(vo);    % number of frequencies
  Ns = 15;            % number of signals
  
  Nz = size(z, 1);    % number of positions
  M = size(z, 2);
  if M == 1
    M = Nz;
    Nz = 1;
    z = z';
  end    
  if M ~= 7
    error('z should be Nx7')
  end
  
  if length(phiDemod) ~= 15
    error('phiDemod should be 1x15 or 15x1')
  end

  % compute detector fields
  mf = zeros(Nf, Nz, Ns);
  for nf = 1:Nf
    mf(nf, :, :) = fieldRSE(p, aIn(nf), fIn(nf), z);
  end
 
  % power signals  
  sp = reshape(sum(abs(mf).^2, 1), Nz, Ns);

  % demod signals
  sd = zeros(Nz, Ns);
  mfa = zeros(Nz, Ns);
  mfb = zeros(Nz, Ns);
  phi = repmat(exp((i * pi / 180) * phiDemod(:)'), Nz, 1);
  for nf = 1:(Nf - ndemod)
    mfa = reshape(mf(nf, :, :), Nz, Ns);
    mfb = reshape(mf(nf + ndemod, :, :), Nz, Ns);
    sd = sd + phi .* mfa .* conj(mfb) ;
  end
  
  % make real and imag parts
  sr = real(sd);
  si = imag(sd);