% 14/01/2005
% M.Mantovani
%
% function [FoutputAmp,FoutputPhs]= Mmfft (Tdata, num, fres, ave)
% 
% Averaging fft with resampled data 
% input:
% - time data
% - number of points
% - sampling frequency, 
% - number of averages
%
% output :
% - FoutputAmp: fft amplitude normalised 
% - FoutputPhs: fft phase in [rad]

function [FoutputAmp,FoutputPhs]= Mmfft (Tdata, num, fres, ave)
    FoutputAmp=zeros(num/2,1);
    FoutputPhs=zeros(num/2,1);

    norm2=0;
    phase=0;
    han=hanning(num);   

    for i=1:ave,
        dat=Tdata((i-1)*num+1:i*num);
        x=fft(dat.*han);
        tut=abs(x(1:(num/2)));
        norm=tut*sqrt(2)/num*sqrt(num/fres);
        norm2=norm2+norm;
        tphase=angle(x(1:(num/2)));
        phase=phase+tphase;
    end
    FoutputAmp=norm2/ave;
    FoutputPhs=phase/ave;
