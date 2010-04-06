% 24/01/05
% M. Mantovani
%
% [Dtime]=Mmgetdata(GPSb,fres,npoints,nframes,channel,nochannels,fsampling)
% 
% This Function get the time signals (given by channel) from a ffl raw data file 
% starting from the GPS time.
% It resamples the time signal with a resampling frequency (fres)
% M.Mantovani
%
% Input:
%
% - GPSb (GPS starting time)
% - resampling frequency (fres) 
% - number of points of the resulting time signal 
%   (npoints=resampling frequency*(GPS stopping time - GPS starting time))
% - number of frames (nframes)
% - channel (channel name to get)
% - nochannel (number of channels to get)
% - fsampling (sampling frequency of the channels)
%
% Output:
% - Dtime (matrix filled by the channels signal in the time domain)
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Dtime]=Mmgetdata(GPSb,fres,npoints,nframes,channel,nochannels,fsampling)

% this file contains the name of the files of frames to analyse
file=char('/virgoData/ffl/raw_bck.ffl');


% Fill matrices with zero
Dtime=zeros(npoints,nochannels);

% get the channels signals and resample these with resampled frequency fres   
    for inc=1:nochannels,
        [data2,a,b,c,d,e,f] = frgetvect(file,channel(inc,:),GPSb,nframes);
        if (fres~=fsampling)
            Dtime(:,inc)=resample(data2,fres,fsampling);
        else
            Dtime(:,inc)=data2;
        end
    end 
