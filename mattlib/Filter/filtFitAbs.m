%
% mf = filtFitAbs(h, f, fMin, fMax, nz, np, nr)
%
% find an S-domain transfer function for h
% (additional arguments are passed to invfreqs)
% 
% h is amplitude at f in Hz
% h must have nearly constant slope outside of fMin < f < fMax 
% nz = number of imaginary zero pairs
% np = number of imaginary pole pairs
% nr = number of real poles and real zeros
%  some number of unbalanced real poles or zeros will be added
%  to fit the slope outside of fMin < f < fMax 
%

function mf = filtFitAbs(h, f, fMin, fMax, nz, np, nr, nMax, errTol)

  % -- init vars
  a = abs(h);
  nLow = find(f < fMin);
  nMid = find(f >= fMin & f < fMax);
  nHai = find(f >= fMax);

  % -- determin slopes and offsets
  pLow = polyfit(log(f(nLow)), log(a(nLow)), 1);
  pHai = polyfit(log(f(nHai)), log(a(nHai)), 1);

  sLow = pLow(1);
  sHai = pHai(1);
  gDC = exp(pLow(2));
  k = exp(pHai(2));

  if( abs(round(sLow) - sLow) > 0.01 )
    error(sprintf('non-integer slope below fMin %f', sLow));
  else
    sLow = round(sLow);
  end

  if( abs(round(sHai) - sHai) > 0.01 )
    error(sprintf('non-integer slope above fMax %f', sHai));
  else
    sHai = round(sHai);
  end

  % -- build reference filter
  if( sLow < 0 )
    zLow = [];
    pLow = zeros(-sLow, 1);
  else
    zLow = zeros(sLow, 1);
    pLow = [];
  end

  n = (sHai - sLow) - (nz - np);
  gDC = gDC / k;
  if( n < 0 )
    f0 = gDC^(1/(sHai - sLow));
    nzh = 0;
    nph = -n;
  elseif( n > 0 )
    f0 = gDC^(1/(sHai - sLow));
    nzh = n;
    nph = 0;
  else
    f0 = sqrt(fMin * fMax);
    nzh = 1;
    nph = 1;
  end

  % divide out reference spectrum
  fRef = filtZPK(zLow, pLow, k);
  hRef = sresp(fRef, f);
  h = h ./ hRef;

  % set fit options and initial values
  opt = optimset;
  opt.MaxFunEvals = 1e3;
  opt.MaxIter = 1e3;

  errTol = log(1 + errTol);

  param = ones(2 * (nz + np + nr), 1) * f0;
  exitval = 0;

  % display initial fit
  [z, p, k] = filtFitAbs_param(param, nz, np, nr, gDC, nzh, nph);
  mf = filtZPK(z, p, k);
  hf = sresp(mf, f);
  subplot(2, 1, 1); loglog(f, abs([h, hf])); title('data and fit');
  subplot(2, 1, 2); semilogx(f, abs(h) ./ abs(hf)); title('data/fit');
  drawnow

  % loop on fitting function
  nStuck = 0;
  for n = 1:nMax

    % check loop condition
    if( max(abs(log(abs(h) ./ abs(hf)))) < errTol )
      fprintf('fit within tolerance...done fitting\n');
      break
    elseif( exitval == 1 )
      nStuck = nStuck + 1;
      if( nStuck > 1 )
        fprintf('unable to further improve fit...done fitting\n');
        break
      end
    else
      nStuck = 0;
    end

    fprintf('fit attempt %d of %d...\n', n, nMax);

    % call fitting function
    [param, val, exitval] = fminsearch('filtFitAbs_err', param, opt, ...
      abs(h), f, nz, np, nr, gDC, nzh, nph);

    % display current fit
    [z, p, k] = filtFitAbs_param(param, nz, np, nr, gDC, nzh, nph);
    mf = filtZPK(z, p, k);
    hf = sresp(mf, f);
    subplot(2, 1, 1); loglog(f, abs([h, hf])); title('data and fit');
    subplot(2, 1, 2); semilogx(f, abs(h) ./ abs(hf)); title('data/fit');
    drawnow
  end

  % include reference filter
  mf = filtProd(mf, fRef);
