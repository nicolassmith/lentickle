% mf = filtMorph(mf, wpm, f, h, wt)
%
% Adjust mf to better fit [f, h]
%  wpm determines the relative weight of phase/magnitude (default = 1)
%   (wpm = 10 makes phase much more important than magnitude)
%  wt is the point-by-point weight (default is all ones)

function [mf, err, err0] = filtMorph(mf, wpm, f, h, Nmax, wt)

  % set default weight
  if nargin < 6
    wt = ones(size(h));
  end
  
  % setup fitting parameters
  mf = filtSort(mf);
  [fz, qz] = getFQ(mf.z);
  [fp, qp] = getFQ(mf.p);

  ncz = find(qz ~= 0);
  ncp = find(qp ~= 0);
  nrz = find(qz == 0);
  nrp = find(qp == 0);

  p0 = [mf.k; fz(ncz); qz(ncz); fz(nrz); ...
	      fp(ncp); qp(ncp); fp(nrp)];
  
  % recasting parameters
  n = zeros(5, 1);
  n(1) =    2 + length(ncz);
  n(2) = n(1) + length(ncz);
  n(3) = n(2) + length(nrz);
  n(4) = n(3) + length(ncp);
  n(5) = n(4) + length(ncp);
  
  % compute initial error
  err0 = filtMorph_erf(p0, f, h, wpm, wt, n);

  % fit
  opt = optimset;
  opt.MaxIter = 1e2;
  opt.MaxFunEvals = 1e5;
  opt.Display = 'off';
  
  for m = 1:Nmax
    [p1, err, exitval] = ...
      fminsearch('filtMorph_erf', p0, opt, f, h, wpm, wt, n);

    if log(err0 / err) < 0.01
      break
    end
  
    if m == Nmax
      warning(['filtMorph - exiting after maximum iterations'])
    end
  end
  
  % recast into filter struct
  mf.k = p1(1);
  mf.z = [filtRes(p1( 2:n(1)-1), p1(n(1):n(2)-1)); p1(n(2):n(3)-1)];
  mf.p = [filtRes(p1(n(3):n(4)-1), p1(n(4):n(5)-1)); p1(n(5):end)];
