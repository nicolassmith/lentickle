% error function used by filtMorph
%
% err = filtMorph_err(p1, f, h0, wpm, wt, n)

function err = filtMorph_erf(p1, f, h0, wpm, wt, n)

  % recast into filter struct
  mf.k = p1(1);
  mf.z = [filtRes(p1( 2:n(1)-1), p1(n(1):n(2)-1)); p1(n(2):n(3)-1)];
  mf.p = [filtRes(p1(n(3):n(4)-1), p1(n(4):n(5)-1)); p1(n(5):end)];

  % compute response
  [b, a] = zp2tf(-mf.z, -mf.p, mf.k);
  h = polyval(b, i * f) ./ polyval(a, i * f);

  % compute error
  r = h0 ./ h;
  lar = log(abs(r));

  %subplot(2, 1, 1)
  %loglog(f, abs([h, h0]), 'x')
  %subplot(2, 1, 2)
  %loglog(f, lar, 'x')
  %pause
  
  err = sum(wt .* (lar).^2) + wpm * sum(wt .* angle(r).^2);
