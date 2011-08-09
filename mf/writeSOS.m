%
% [g, ca] = writeSOS(mf, fs, fileName)
%
%  writeSOS(mf, fs, fileName)   re-organizes the coefficients 
%  of a cascaded, second order section IIR filter, from the
%  order produced by a Matlab sos command, to the order 
%  used in real-time C realization (ala Embree). G is the 
%  overall gain factor, and CA is a column vector containing 
%  the filter coefficients in the order:
%
%        [a11 a21 b11 b21 a12 a22 b12 b22 ... ] 
%
%  The b0i are all unity in this convention. If the optional 
%  file name is included, the coefficients are written to the
%  file in the above order, delimited by commas, with the gain
%  factor in the first element, using 15 digits.
%
% >> originally "sos_shuffle" by Peter Fritschel <<
%

function [g, ca] = writeSOS(mf, fs, fileName)

  sos = getSOS(mf, fs);

  g = prod(sos(:,1));
  b = [sos(:,2)./sos(:,1), sos(:,3)./sos(:,1)];
  a = [sos(:,5), sos(:,6)];

  ab = [a b];
  abT = ab';

  ca = abT(:); 

  if( nargin == 3 )
    fid = fopen(fileName, 'w');
    fprintf(fid,'%15.14f', g);
    fprintf(fid,', %15.14f', ca);
    status = fclose(fid);
  end
