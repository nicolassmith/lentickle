%
% function [f, a] = myfft( xlist, delT )
%

function [f, a] = myfft( xlist, delT )

xsize = size(xlist,1);
npow = ceil( log2(xsize) );
ysize = 2^npow;
if ysize > xsize
  ysize = ysize / 2;
end
ylist = fft( xlist, ysize );
ysize = floor(ysize / 2);

f = (0:(ysize-1))' / (2 * delT * ysize);
a = ylist(1:ysize) / ysize;


