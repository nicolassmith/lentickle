% 20/01/05
% M.Mantovani
%
% Program evolutionchNWhor.m
% 
% This program save in vectors called B(7/8)q(1/2)_(p/q)h_(N/W)(I/E)
% the values of the corrispective matrix element for different demodulation 
% phases. 
% the demodulation phase values are collected in the vector evolh
%

% in the file is written the input data matrix in the format:
% GPSb GPSe dempha
% filen='lines-at-HF-on-tytx-790972162-a.txt';


TxTy=1;   % for horizontal matrix
startp=1; % starting index of the filename matrix 
stopp=7; % stopping index of the filename matrix 
fres=500; % resampling frequency for the matrix measurement
ave=15;   % number of averages for the matrix measurement

len=stopp-startp+1;  % length of the vectors
Matrix=zeros(16,6);

evolh=zeros(len,8);
chty=zeros(len,6,8);
chtyq=zeros(len,6,8);
chq=zeros(len,6,8);

Data=load(filen);

if (len>0)
for i=startp:stopp,
    GPSb=Data(i,1);
    GPSe=Data(i,2);
    [Matrix]=Mmeasure(TxTy,GPSb,GPSe,fres,ave,'','HF',1);
    for inc=1:8,
        for compt=1:6,
            chty(i,compt,inc)=abs(Matrix(2*inc-1,compt));
            chq(i,compt,inc)=abs(Matrix(2*inc,compt));
        end
    end
    for j=1:8,
        evolh(i,j)=-Data(i,2*j+1);
    end
end
end

