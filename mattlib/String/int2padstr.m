function str = int2padstr(a, pad)

str = sprintf(['%.' int2str(pad) 'd'], a);

return