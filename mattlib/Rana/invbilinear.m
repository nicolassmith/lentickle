function [zr,pr,kr] = invbilinear(z,p,k,fs)

% Inverse bilinear transform; 
% takes either zeros, poles, gain and sampling frequency 
% or numerator (b), denumerator (a) and sampling frequency as argument,
% i.e
% [z,p,k]=invbilinear(zd,pd,kd,fs); or
% [b,a]=invbilinear(bd,ad,fs);
%
% However, using b and a is only recomended up to second order
% since for higher order rounding error cause huge errors.
% (-> error message:  Matrix is close to singular or badly scaled.)
%
% Stefan Ballmer, August 14, 2002

if(nargin == 4)
 zp=-z;
 pp=-p;
 kp=k;
 
 [zrp,prp,krp]=bilinear(zp,pp,kp,0.5);
 zr=-zrp*(2*fs);
 pr=-prp*(2*fs);
 kr=real(krp);
elseif(nargin==3)
 b=z.*((-1).^(-length(z)+1:0));
 a=p.*((-1).^(-length(p)+1:0));
 fs=k;
  
 [brp,arp]=bilinear(b,a,0.5);

 br=brp.*((-2*fs).^(-length(brp)+1:0));
 ar=arp.*((-2*fs).^(-length(arp)+1:0));

 zr=br/ar(1);
 pr=ar/ar(1);
end
