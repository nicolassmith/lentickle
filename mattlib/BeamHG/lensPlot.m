
% [phi, z0, z] = lensPlot(lambda, f, d, z0, z, dv)
%
% f is an N element array of focal lengths
% d is an N + 1 element array of distances between lenses
%   (and one on either end)
% dv is the distance plotting vector
%
% z0 and z are the HG basis parameters (input and output)
% phi is the accumulated guoy phase at the output
%
% (see also lensHG, beamRW and beamHG for computation without plotting)
%
%% Example (in millimeters):
% lambda = 1064e-6;
% z0 = 60e3;
% z = 15e3;
% l = (0:0.001:0.5)' * 1000;
% f1 = [220 -20 -10];
% d1 = [0; 203; 100; 150];
% lensPlot(lambda, f1, d1, z0, z, l);


function [phi, z0, z, pv, bv] = lensPlot(lambda, f, d, z0, z, l)

  % mix lens positions into plot positions
  lLens = cumsum(d(1:end));
  [lAll, nSort] = sort([lLens(:); l(:)]);
  nLens = find(nSort <= length(f));

  dv = [lAll(1); diff(lAll)];
  fv = zeros(length(dv) - 1, 1);
  fv(nLens) = f;
  ll = cumsum(dv);
  
  % just to check...
  %[(1:30)' ll(1:30) dv(1:30)]
  %[nLens ll(nLens) lLens]

  [phi, z0, z, pv, bv] = lensHG(fv, dv, z0, z);
  [Rv, wv] = beamRW(imag(bv), real(bv), lambda);
  
  % plot beam size
  subplot(2, 1, 1)
  plot(ll, wv)
  lineAtX(lLens)
  title('Beam Radius')
  
  % plot guoy phase
  subplot(2, 1, 2)
  plot(ll, pv * 180 / pi)
  lineAtX(lLens)
  title('Guoy Phase')
  ylabel('degrees')
