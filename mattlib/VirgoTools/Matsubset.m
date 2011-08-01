

function OutMat=Matsubset(InMat, Bitr1, Bitr2, Bitc)

% find outmatrix dimension

rows=0;
columns=0;

for i=1:8,
    rows=rows+(bitget(Bitr1,i));
    rows=rows+(bitget(Bitr2,i));
end
for i=1:6,
    columns=columns+(bitget(Bitc,i));
end

OutMat=zeros(rows,columns);

n=1;
m=1;
for i=1:6
    if(bitget(Bitc,i))
        for j=1:8
           if(bitget(Bitr1,j))
              OutMat(m,n)=InMat(j,i);
              m=m+1;
           end
        
        end
        for j=1:8
           if(bitget(Bitr2,j))
               OutMat(m,n)=InMat(8+j,i);
               m=m+1;
           end
        end
        if(m>1)
          m=1;
          n=n+1;
      end
   end
end