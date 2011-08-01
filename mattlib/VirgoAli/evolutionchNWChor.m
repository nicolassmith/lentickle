% 20/01/05
% M.Mantovani
%
% Program evolutionchNWhor.m
% 
% This program save in vectors called B(7/8)q(1/2)_(p/q)h_(N/W)(I/E)
% the values of the corrispective matrix element for different demodulation 
% phases. 
% the demodulation phase values are collected in the vector evol
%

% in the file is written the input data matrix in the format:
% GPSb GPSe dempha
%filen='lines-at-HF-on-tytx-790972162-a.txt';


TxTy=1;   % for horizontal matrix
startp=1; % starting index of the filename matrix 
stopp=19; % stopping index of the filename matrix 
fres=500; % resampling frequency for the matrix measurement
ave=10;   % number of averages for the matrix measurement

len=stopp-startp+1;  % length of the vectors
Matrix=zeros(16,6);

evol=zeros(len,1);
B2q1_ph_PR=zeros(len,1);
B2q1_qh_PR=zeros(len,1);
B2q2_ph_PR=zeros(len,1);
B2q2_qh_PR=zeros(len,1);
B2q1_ph_NI=zeros(len,1);
B2q1_qh_NI=zeros(len,1);
B2q2_ph_NI=zeros(len,1);
B2q2_qh_NI=zeros(len,1);
B2q1_ph_NE=zeros(len,1);
B2q1_qh_NE=zeros(len,1);
B2q2_ph_NE=zeros(len,1);
B2q2_qh_NE=zeros(len,1);
B2q1_ph_WI=zeros(len,1);
B2q1_qh_WI=zeros(len,1);
B2q2_ph_WI=zeros(len,1);
B2q2_qh_WI=zeros(len,1);
B2q1_ph_WE=zeros(len,1);
B2q1_qh_WE=zeros(len,1);
B2q2_ph_WE=zeros(len,1);
B2q2_qh_WE=zeros(len,1);


Data=load(filen);

if (len>0)
for i=startp:stopp,
    GPSb=Data(i,1);
    GPSe=Data(i,2);
    demph=Data(i,3);
    [Matrix]=Mmeasure(TxTy,GPSb,GPSe,fres,ave,'','HF',1);
    B2q1_ph_NI(i,1)=Matrix(1,1);
    B2q1_qh_NI(i,1)=Matrix(2,1);
    B2q2_ph_NI(i,1)=Matrix(3,1);
    B2q2_qh_NI(i,1)=Matrix(4,1);
    B2q1_ph_NI(i,1)=Matrix(1,3);
    B2q1_qh_NI(i,1)=Matrix(2,3);
    B2q2_ph_NI(i,1)=Matrix(3,3);
    B2q2_qh_NI(i,1)=Matrix(4,3);
    B2q1_ph_NE(i,1)=Matrix(1,4);
    B2q1_qh_NE(i,1)=Matrix(2,4);
    B2q2_ph_NE(i,1)=Matrix(3,4);
    B2q2_qh_NE(i,1)=Matrix(4,4);
    B2q1_ph_WI(i,1)=Matrix(1,5);
    B2q1_qh_WI(i,1)=Matrix(2,5);
    B2q2_ph_WI(i,1)=Matrix(3,5);
    B2q2_qh_WI(i,1)=Matrix(4,5);
    B2q1_ph_WE(i,1)=Matrix(1,6);
    B2q1_qh_WE(i,1)=Matrix(2,6);
    B2q2_ph_WE(i,1)=Matrix(3,6);
    B2q2_qh_WE(i,1)=Matrix(4,6);
    evol(i,1)=-demph;
    i=i+1
end
end

