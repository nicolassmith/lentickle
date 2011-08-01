% 24/01/05
% M.Mantovani
%
% function [frepha]=Mmlinesearch(MfftA,freq,line)
%
% This function find the coordinate of the frequency line of the mirror
% Input:
% - matrix of the mirrors fft amplitude (MfftA)
% - frequency vector (freq)
% - line (frequency vector for the lines on the mirrors)
%
% Output:
% - frepha (vector of the indices of the frequency vectors correspondent to 
%           the line)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [frepha]=Mmlinesearch(MfftA,freq,line)

% frequency range for searching the line in the FFT data
tol=0.2*(freq(2)-freq(1))/0.05;
 for compt=1:6,  
        tut=freq-line(1,compt);
        vect=find(abs(tut)<tol);
        maxfftmir(1,compt)=max(MfftA(compt,vect));
        indexmir=find((MfftA(compt,vect)-maxfftmir(1,compt))==0);
        if (length(indexmir)>1)
            disp('cannot find the line:');
            disp(compt);
            indexmir=max(indexmir)-round(length(indexmir)/2);
        end
        frepha(1,compt)=vect(1,1)-1+indexmir; 
 end 
