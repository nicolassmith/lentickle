
function [value,index] = Mmax(data)

[value,index]=max(data);
 if (length(index)>1)
     index=index(1);
 end
 if (length(value)>1)
     value=value(1);
 end