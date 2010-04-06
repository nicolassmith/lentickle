% rms = ampSpectrumRMS(f, amp)
%

function rms = ampSpectrumRMS(f, amp)

  df = -1 * diff(f(end:-1:1)');
  rms = sqrt(cumsum(amp(end:-1:2)'.^2 .*df));
  rms = [rms(end:-1:1); 0];
