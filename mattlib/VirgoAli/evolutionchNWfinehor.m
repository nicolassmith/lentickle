% 20/01/05
% M.Mantovani
%
% Program evolutionchNW.m
% 
% This program save in vectors called B(7/8)q(1/2)_(p/q)h_(N/W)(I/E)
% the values of the corrispective matrix element for different demodulation 
% phases. 
% the demodulation phase values are collected in the vector evolh
%

% in the file is written the input data matrix in the format:
% GPSb GPSe dempha
% filen='lines-at-HF-on-tytx-791409666-af.txt';


TxTy=1;   % for horizontal matrix
startp=1; % starting index of the filename matrix 
stopp=13; % stopping index of the filename matrix 
fres=500; % resampling frequency for the matrix measurement
ave=10;   % number of averages for the matrix measurement

len=stopp-startp+1;  % length of the vectors
Matrix=zeros(16,6);

evolh=zeros(len,8);
B7q1_ph_NI=zeros(len,1);
B7q1_qh_NI=zeros(len,1);
B7q2_ph_NI=zeros(len,1);
B7q2_qh_NI=zeros(len,1);
B7q1_ph_NE=zeros(len,1);
B7q1_qh_NE=zeros(len,1);
B7q2_ph_NE=zeros(len,1);
B7q2_qh_NE=zeros(len,1);
B8q1_ph_WI=zeros(len,1);
B8q1_qh_WI=zeros(len,1);
B8q2_ph_WI=zeros(len,1);
B8q2_qh_WI=zeros(len,1);
B8q1_ph_WE=zeros(len,1);
B8q1_qh_WE=zeros(len,1);
B8q2_ph_WE=zeros(len,1);
B8q2_qh_WE=zeros(len,1);

Data=load(filen);

if (len>0)
 for i=startp:stopp,
    GPSb=Data(i,1);
    GPSe=Data(i,2);
    [Matrix]=Mmeasure(TxTy,GPSb,GPSe,fres,ave,'','HF',1);
    B7q1_ph_NI(i,1)=Matrix(9,3);
    B7q1_qh_NI(i,1)=Matrix(10,3);
    B7q2_ph_NI(i,1)=Matrix(11,3);
    B7q2_qh_NI(i,1)=Matrix(12,3);
    B7q1_ph_NE(i,1)=Matrix(9,4);
    B7q1_qh_NE(i,1)=Matrix(10,4);
    B7q2_ph_NE(i,1)=Matrix(11,4);
    B7q2_qh_NE(i,1)=Matrix(12,4);
    B8q1_ph_WI(i,1)=Matrix(13,5);
    B8q1_qh_WI(i,1)=Matrix(14,5);
    B8q2_ph_WI(i,1)=Matrix(15,5);
    B8q2_qh_WI(i,1)=Matrix(16,5);
    B8q1_ph_WE(i,1)=Matrix(13,6);
    B8q1_qh_WE(i,1)=Matrix(14,6);
    B8q2_ph_WE(i,1)=Matrix(15,6);
    B8q2_qh_WE(i,1)=Matrix(16,6);
    for j=1:8;
    evolh(i,j)=-Data(i,2*j+1);
    end
 end
end
delta=(90/(evolh(2,1)-evolh(1,1)));
 if (max(evolh)==180)
    for i=1:len,
        if (i>delta)
           B7q1_qhs_NI(i,1)=B7q1_qh_NI(i-delta,1);
           B7q2_qhs_NI(i,1)=B7q2_qh_NI(i-delta,1);
           B7q1_qhs_NE(i,1)=B7q1_qh_NE(i-delta,1);
           B7q2_qhs_NE(i,1)=B7q2_qh_NE(i-delta,1);
           B8q1_qhs_WI(i,1)=B8q1_qh_WI(i-delta,1);
           B8q2_qhs_WI(i,1)=B8q2_qh_WI(i-delta,1);
           B8q1_qhs_WE(i,1)=B8q1_qh_WE(i-delta,1);
           B8q2_qhs_WE(i,1)=B8q2_qh_WE(i-delta,1);
       end
        if (i<delta)
          B7q1_qhs_NI(i,1)=B7q1_qh_NI(i+delta,1);
          B7q2_qhs_NI(i,1)=B7q2_qh_NI(i+delta,1);
          B7q1_qhs_NE(i,1)=B7q1_qh_NE(i+delta,1);
          B7q2_qhs_NE(i,1)=B7q2_qh_NE(i+delta,1);
          B8q1_qhs_WI(i,1)=B8q1_qh_WI(i+delta,1);
          B8q2_qhs_WI(i,1)=B8q2_qh_WI(i+delta,1);
          B8q1_qhs_WE(i,1)=B8q1_qh_WE(i+delta,1);
          B8q2_qhs_WE(i,1)=B8q2_qh_WE(i+delta,1);
      end
    end
end
