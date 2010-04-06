% sort poles and zeros in mf
%
% mf = filtSort(mf)

function mf = filtSort(mf)

  [z, n] = sort(mf.z);
  mf.z = mf.z(n);

  [p, n] = sort(mf.p);
  mf.p = mf.p(n);
