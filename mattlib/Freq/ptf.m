% makes a matrix representing power as a funciton of time and frequency
%
% Arguments:
% dt         = time step in time series data
% data       = time series data
% dt_out     = time step in time-frequency matrix as a multiple of dt
% fft_width  = log2 of the number of points to be used in each fft
%
% Return:
% P          = power(t(j), f(i))
% t          = array of times
% f          = array of frequencys
%

function [P, t, f] = MakePtf(dt, data, dt_out, fft_width)

if size(data, 1) > size(data, 2)
  data = data';
end

N = 2^fft_width;
M = floor( (length(data) - N) / dt_out);
P = zeros(N, M);

for m = 1:M
  n = (m - 1) * dt_out + 1;
  P(:, m) = fft( data(n:(n + N - 1)) )';
end

P = P(1:N/2, :) .* conj(P(1:N/2, :));

t = 0:(M - 1);
t = t * (dt * dt_out);
t = t + (dt * N/2);

f = 0:(N/2 - 1);
f = f / (dt * N);

return;