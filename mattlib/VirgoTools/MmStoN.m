% 31/01/05
% 
% function [SNmatrix,S2N]=MmStoN(QfftA,frepha,freq)
% 
% This function compute the Signal to Noise ratio on the quadrants signals
%
% Input:
% - QfftA (quadrants fft matrix)
% - frepha (vector with the lines frequencies coordinate)
% - freq (frequency vector)
% 
% Output:
% - SNmatrix (Signal to Noise matrix)
% - S2N mean value for the matrix coefficients
% 
% M.Mantovani

function [SNmatrix,S2N]=MmStoN(QfftA,frepha,freq)

SNmatrix=zeros(16,6);
delta=round(0.2/(freq(2)-freq(1)));
if (delta==0)
    delta=1;
end
noisevect=zeros(1,2*delta);
for compt=1:6,
    for inc=1:16,
        for i=2*delta:3*delta,
            noisevect(1,i)=QfftA(inc,frepha(1,compt)+i);
            j=i+delta;
            noisevect(1,j)=QfftA(inc,frepha(1,compt)-i);
            noise=mean(noisevect);
        end
        if (noise~=0)
            SNmatrix(inc,compt)=QfftA(inc,frepha(1,compt))/noise;
        else 
            disp('noise zero');
        end
    end 
end
S2N=mean(mean(SNmatrix));

