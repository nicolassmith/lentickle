% 20/01/05
% M.Mantovani
%
% Program evolutionchNWhor.m
% 
% This program save in vectors called B(7/8)q(1/2)_(p/q)h_(N/W)(I/E)
% the values of the corrispective matrix element for different demodulation 
% phases. 
% the demodulation phase values are collected in the vector evolv
%

% in the file is written the input data matrix in the format:
% GPSb GPSe dempha
% filen='lines-at-HF-on-tytx-790972162-a.txt';


TxTy=0;   % for horizontal matrix
startp=1; % starting index of the filename matrix 
stopp=11; % stopping index of the filename matrix 
fres=500; % resampling frequency for the matrix measurement
ave=15;   % number of averages for the matrix measurement

len=stopp-startp+1;  % length of the vectors
Matrix=zeros(16,6);

evolv=zeros(len,8);
chtx=zeros(len,6,8);
chtxq=zeros(len,6,8);

Data=load(filen);

if (len>0)
for i=startp:stopp,
    GPSb=Data(i,1);
    GPSe=Data(i,2);
    [Matrix]=Mmeasure(TxTy,GPSb,GPSe,fres,ave,'','HF',1);
    for inc=1:8,
        for compt=1:6,
            chtx(i,compt,inc)=abs(Matrix(2*inc-1,compt));
            chtxq(i,compt,inc)=abs(Matrix(2*inc,compt));
        end
    end
    for j=1:8,
        evolv(i,j)=-Data(i,2*j+2);
    end
end
end
