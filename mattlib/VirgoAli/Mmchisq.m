% 27/01/05
%
% function [B,maxout,avgout] = Mmchisq(filename,subset)
% 
% This function compute the control matrix using che chi square criteria
%
% Input:
% filename (name of the file in which the measured matrix is saved)
% subset - 'N' for the North cavity
%        - 'W' for the West cavity
%        - 'F' for the full interferometer
%
% Output:
% B=control matrix
% maxout is the maximum error for the mirror signals 
% avgout is the average of the mirror signals errors
% 
% M.Mantovani

function [B,maxout,avgout] = Mmchisq(filename,subset)


% Quadrant errors (for the moment I've used the same costant value 
%                   for every quadrants)
qerr(1,1)=0.1;
qerr(2,1)=0.1;
qerr(3,1)=0.1;
qerr(4,1)=0.1;
qerr(5,1)=0.1;
qerr(6,1)=0.1;
qerr(7,1)=0.1;
qerr(8,1)=0.1;
qerr(9,1)=0.1;
qerr(10,1)=0.1;
qerr(11,1)=0.1;
qerr(12,1)=0.1;
qerr(13,1)=0.1;
qerr(14,1)=0.1;
qerr(15,1)=0.1;
qerr(16,1)=0.1;

Matrix=load(filename);

% n number of quadrant signals n>m
% m number of mirrors signals

switch (subset)
case {'N'}
    Matrixs=Matsubset(Matrix,0,1+4+2+8,4+8);
    n=4;
    m=2;
case {'W'}
    Matrixs=Matsubset(Matrix,0,16+32+64+128,16+32);
    n=4;
    m=2;
case {'F'} % I did not consider the BS
    Matrixs=Matsubset(Matrix,255,255,1+4+8+16+32);
    n=16;
    m=5;
otherwise 
    disp('unknown subset')
end

% diagonal nxn matrix representing the quadrants error (V)   
qerrm=(qerr(1,1)^2)*eye(n,n);
 
err=zeros(m,1);
A=zeros(m,m);

% filling A (mxm matrix)

for j=1:m,
  for k=1:m,

    A(k,j)=0;

    for i=1:n,
      A(k,j)=A(k,j)+ (Matrixs(i,j)*Matrixs(i,k)/qerr(i,1)^2);
    end
  end
end

% inverse of A
invA=inv(A);

% extimation of the mirrors signals error
for i=1:m
  err(i)=0;
  for k=1:n
    tmp=0;
    for j=1:m
      tmp=tmp+invA(i,j)*Matrixs(k,j);
    end
    err(i)=err(i)+tmp^2/qerr(k)^2;
  end
  err(i)=sqrt(err(i));
end


% Control Matrix B=(A^(-1)*aT*V^(-1))

B=invA*(Matrixs')*inv(qerrm);


if (subset=='F')
    Btmp=zeros(6,16);
    Btmp(1,:)=B(1,:);
    for i=1:4,
        Btmp(i+2,:)=B(i+1,:);
    end

    B=Btmp;
end


outfilename='outmatrix.txt';
[rows,columns]=size(B);
Mmsavematrix(B,rows,columns,outfilename); 

maxout=max(err);
avgout=mean(err);

