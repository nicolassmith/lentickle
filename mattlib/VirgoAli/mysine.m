
function [out]=mysine(x,xdata)

out=abs(x(1)*sin((xdata-x(2))/180*pi));
