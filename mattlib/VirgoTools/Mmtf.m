% 24/01/2005
% 
% Function [FoutputAmp,FoutputPhs]= Mmtf(Tdata1,Tdata2, num, fres, ave)
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
% M.Mantovani
function [FoutputAmp,FoutputPhs]= Mmtf(Tdata1,Tdata2, num, fres, ave)
debug=1;


    FoutputAmp=zeros(num/2,1);
    FoutputPhs=zeros(num/2,1);

    norm=0;
    phase=0;
    tf2=0;
    han=hanning(num);   

    for i=1:ave,
        dat1=Tdata1((i-1)*num+1:i*num); 
        dat2=Tdata2((i-1)*num+1:i*num);
        x1=fft(dat1.*han);
        x2=fft(dat2.*han);
        tf=x1./x2;
        tf2=tf2+tf;
        
    end
    tf2=tf2/ave;
    FoutputAmp=abs(tf2(1:(num/2)));
    FoutputPhs=angle(tf2(1:(num/2)));
