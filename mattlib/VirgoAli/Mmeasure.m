% 31/01/2005
%
% function [Matrix]=Mmeasure(TxTy,GPSb,GPSe,fres,ave,filename,lines,checkpast)
%
% This function can make the optical matrix knowing the GPS time of the 
% event, the directions of the lines (vertical or horizontal) and others parameters
%
% use the functions:
% 
% - Mmstartup.m
% - Mmgetdata.m
% - Mmlinesearch.m
% - Mmlinesearchquad.m
% - Mmfft.m
% - Mmtf.m
% - MmStoN.m
%
% Input:
% - TxTy horizontal or vertical direction
%  [for (TxTy)=0 the lines are on Tx], [for (TxTy)=1 the lines are on Ty]
% - GPSb starting time 
% - GPSe ending time
% - resampling frequency (fres)
%   It must be smaller then 500Hz (or equal)
% - numbers of averages of the fft measurement (ave)
% - filename
% - lines: different sets of applied lines ('LF' for low frequency lines, 'MLF' for medium-low frequency lines, 'MF' for medium frequency lines,
%          'HF' for low frequency lines)
% - checkpast (0 ignore the saved matrix, 1 load the saved matrix)
% - calibration (0 for the TF calibrated matrix, 1 for the TF not calibrated matrix, 2  for the quad fft matrix)
% Output:
% - Matrix (calibrated or not calibrated matrix)
%
% 
% M.Mantovani


function [Matrix]=Mmeasure(TxTy,GPSb,GPSe,fres,ave,filename,lines,checkpast,calibration)

err=0;

% default switches to change behaviour of the script
standalone=0;          % 0: to be used in Matlab, 1: to compile 
warning off;           % print extra output
debug=0;               % switch on/off debug output

if (standalone)

     disp([sprintf('\n'),'Matrix measurement v1r0 (Matlab stand-alone) -- mantovan@ego-gw.it --  19.01.05']);

     TxTy=str2num(TxTy);
     GPSb=str2num(GPSb);
     GPSe=str2num(GPSe);
     fres=str2num(fres);
     ave=str2num(ave);
end

name=sprintf('Matrix%d-%d-%d-%d-%d-%d.txt',TxTy,GPSb,GPSe,fres,ave,calibration);

if (exist(filename))
        Matrix=load(filename);
else 
    if (exist(name) & checkpast==1)
        Matrix=load(name);
	else

    [phat,cohethre,cohesearchrange,channel,chanmir,fsamplingQ,fsamplingM,line,calfacta,calfactp]=Mmstartup(TxTy,lines);   

    nos=GPSe-GPSb;    % Number of seconds used
    nframes=nos;      % Number of frames
    npoints=nos*fres; % Number of time data points

    % Find maximum number of points (i.e time window lengths)
    % for normal fft with averages
    n=1;
    while (2^n*ave<npoints)
        n=n+1;
    end
    n=n-1;
    2^n/fres

    % Find maximum number of points for fft used for determining the
    % sign
    n2=1;
    while (2^n2<npoints)
        n2=n2+1;
    end
    n2=n2-1;

    num=2^n;     % Time window for FFT

    % To reduce number of points after FFT, set fin to a constant number
    % smaller than 2^(n-1)
    fin=2^(n-1); % full fft
    numreso=2^n2; %number of points taken for phase evaluation
    han=hanning(num);     % window for coherence computation
    freq=[0:1:(num/2-1)]'/num*fres;     % full frequency vector 

    % Get the .ffl data and make time domain matrices for the quadrants 
    % and the mirrors
    [Qtime]=Mmgetdata(GPSb,fres,npoints,nframes,channel,16,fsamplingQ);
    [Mtime]=Mmgetdata(GPSb,fres,npoints,nframes,chanmir,6,fsamplingM);

    % Fill matrices with zeros
    QfftA=zeros(16,fin);
    QfftP=zeros(16,fin);
    MfftA=zeros(6,fin);
    MfftP=zeros(6,fin);
    Matrix=zeros(16,6);
    fftquad=zeros(16,6);
    % Make the quadrants fft
    for inc=1:16,
        [Tamp,Tphs]=Mmfft(Qtime(:,inc), num, fres, ave);
        QfftA(inc,1:fin)=Tamp(1:fin)';
        QfftP(inc,1:fin)=Tphs(1:fin)';
    end
    %Make the mirrors fft
    for compt=1:6,   
       [Tamp,Tphs]=Mmfft(Mtime(:,compt), num, fres,ave);
       MfftA(compt,1:fin)=Tamp(1:fin)';
       MfftP(compt,1:fin)=Tphs(1:fin)';
    end   
    [frepha]=Mmlinesearch(MfftA,freq,line);
    [frequad,ch]=Mmlinesearchquad(QfftA,freq,line,frepha);
    [SNmatrix,S2N]=MmStoN(QfftA,frepha,freq);
    for compt=1:6,
        %For each mirror frequency find the line on the quadrants
        for inc=1:16,
            %make the quadrant fft matrix
            fftquad(inc,compt)=QfftA(inc,frequad(1,compt));
            % compute coherence between the lines
            % (if the coherence at the given frequency is < cohethre 
            % set the matrix coefficient to 0)
    
            cohe=cohere(Qtime(:,inc), Mtime(:,compt), num,fres,han);
   
            MTF=max(abs(cohe(frepha(1,compt)-cohesearchrange:frepha(1,compt)+cohesearchrange)));
    
            if (MTF>cohethre)
                index2=find(abs(cohe)-MTF==0);
                if (length(index2)>1)
                   index2=index2(1,1);
                end
            
                [transferA,transferP]=Mmtf(Qtime(:,inc),Mtime(:,compt),num,fres,ave);
                sign=transferP(index2)+calfactp(1,compt);
                if(bitand(debug,1))
                    sign
                end
                if abs(sign)>phat 
                    Matrix(inc,compt)=-transferA(index2);
                else            
                    Matrix(inc,compt)=transferA(index2); 
                end         
            else
                Matrix(inc,compt)=0;
            end
        end
    end
    Matrixncal=Matrix;
    for compt=1:6;
        Matrixcal(:,compt)=calfacta(1,compt)*Matrix(:,compt);
    end
        
    if (calibration==0)
        Matrix=Matrixcal;
    else 
        if (calibration==1)
            Matrix=Matrixncal;
        else
            if (calibration==2)
                Matrix=fftquad;
            end
        end
    end
            
            
    if(size(filename)==0)
        filename=sprintf('Matrix%d-%d-%d-%d-%d-%d',TxTy,GPSb,GPSe,fres,ave,calibration);
    end
    filename=[filename,'.txt'];

    err=Mmsavematrix(Matrix,16,6,filename);

    if (err)
     disp([sprintf('\n Error: Could not save file %s\n',filename)]);
    end
    
    filenameSN=sprintf('Matrix%d-%d-%d-%d-%dSN',TxTy,GPSb,GPSe,fres,ave)
    filenameSN=[filenameSN,'.txt'];
 
    err=Mmsavematrix(SNmatrix,16,6,filenameSN);

    if (err)
        disp([sprintf('\n Error: Could not save file %s\n',filenameSN)]);
    end
end
Matrix;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Shape of the matrix in the horizontal direction 
%                    PRty   BSty   NIty    NEty     WIty    WEty
%Pr_B2_q1_ACph       
%Pr_B2_q1_ACqh
%Pr_B2_q2_ACph             
%Pr_B2_q2_ACqh
%Pr_B5_q1_ACph      
%Pr_B5_q1_ACqh
%Pr_B5_q2_ACph             
%Pr_B5_q2_ACqh
%Pr_B7_q1_ACph      
%Pr_B7_q1_ACqh
%Pr_B7_q2_ACph             
%Pr_B7_q2_ACqh
%Pr_B8_q1_ACph      
%Pr_B8_q1_ACqh
%Pr_B8_q2_ACph             
%Pr_B8_q2_ACqh
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Shape of the matrix in vertical direction 
%                    PRtx   BStx   NItx    NEtx     WItx    WEtx
%Pr_B2_q1_ACpv       
%Pr_B2_q1_ACqv
%Pr_B2_q2_ACpv             
%Pr_B2_q2_ACqv
%Pr_B5_q1_ACpv      
%Pr_B5_q1_ACqv
%Pr_B5_q2_ACpv             
%Pr_B5_q2_ACqv
%Pr_B7_q1_ACpv      
%Pr_B7_q1_ACqv
%Pr_B7_q2_ACpv             
%Pr_B7_q2_ACqv
%Pr_B8_q1_ACpv      
%Pr_B8_q1_ACqv
%Pr_B8_q2_ACpv             
%Pr_B8_q2_ACqv
%
