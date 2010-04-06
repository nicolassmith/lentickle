% 28/01/05  Andreas Freise
%
% function [err]=Mmsavematrix(matrix,rows,columns,filename)
% 
% Function so save matrix using fprintf
% Input:
% - matrix (2 dimensional)
% - rows: number of rows
% - columns: number of columns
% - filename
% 
% Returns err=1 when file could not be opened


function [err]=Mmsavematrix(matrix,rows,columns,filename)

err=0;
fid=fopen(filename,'w');
if (~fid)
     err=1;
   return;
end

for i=1:rows
  for j=1:columns

    fprintf(fid,'%15.3g  ',matrix(i,j));
  end
  fprintf(fid,'\n');
end

fclose(fid);

