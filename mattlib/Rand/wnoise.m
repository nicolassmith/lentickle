%
% x = wnoise(fs, N)
%
% generates gaussian white noise at sample frequency fs
%

function x = wnoise(fs, N)

  if( length(N) == 1 )
    N = [1, N];
  end

  x = randn(N) * sqrt(fs);
