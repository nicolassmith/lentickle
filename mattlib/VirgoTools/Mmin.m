
function index = Mmin(data)

[value,index]=min(data);
 if (lenght(index)>1)
     index=index(1);
 end