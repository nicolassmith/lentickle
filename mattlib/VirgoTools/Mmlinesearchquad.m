% 24/01/05
% M.Mantovani
% 
% function [frequad,ch]=Mmlinesearchquad(QfftA,freq,line,frepha);
% 
% This function find the coordinate of the frequency line of the quadrants
% Input:
% - matrix of the quadrant fft amplitude (QfftA)
% - frequency vector (freq)
% - line (frequency vector for the lines on the mirrors)
% - frepha (vector of the indices of the frequency vectors correspondent to 
%           the line)
%
% Output:
% - frequad (vector of the indices of the frequency vectors correspondent to 
%           the line)
% - ch vector of the quadrant channels used to find the lines

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [frequad,ch]=Mmlinesearchquad(QfftA,freq,line,frepha);

% frequency range for searching the line in the FFT data
tol=0.2*(freq(2)-freq(1))/0.05;
ch=zeros(1,6);
delta=round(0.2/(freq(2)-freq(1)));

  for compt=1:6,  
        ampl=0;
        count=1;
    while ((ampl<4) & (count<17))
        tut=freq-line(1,compt);
        vect=find(abs(tut)<tol);
        for i=2*delta:3*delta,
            noisevect(1,i)=QfftA(count,frepha(1,compt)+i);
            j=i+delta;
            noisevect(1,j)=QfftA(count,frepha(1,compt)-i);
            noise=mean(noisevect);
            if (noise~=0)
                ampl=QfftA(count,frepha(1,compt))/noise;
            else 
                ampl=0;
            end
        end
        count=count+1;
    end
    inc=count-1;
    maxfftquad(1,compt)=max(QfftA(inc,vect));
    ch(1,compt)=inc;
    indexquad=find((QfftA(inc,vect)-maxfftquad(1,compt))==0);
        if (ampl<4)
            disp('cannot find on the quadrants the line:');
            disp (compt);
            indexquad=max(indexquad)-round(length(indexquad)/2);
        end
    frequad(1,compt)=vect(1,1)-1+indexquad; 
 end 
