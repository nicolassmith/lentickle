function [ret,name,sosname] = onlinefilter(file,module,varargin)

% reads online filter files
% --->always assumes a sampling frequency of 16384Hz!<---
% uses functions fptool and invbilinear
% 
%
% Examples:
% 1) read file L1LSC.txt, filter bank RM, filter modules 0,2,3,4
%    return the online filter coeffitents of the combined filter
%      coef=onlinefilter('L1LSC.txt','RM',0,2,3,4);
%
% 2) additionally make a bode plot of the combined filter
%    and return the name of the filter module (separated by / in more then one)
%      [coef,name]=onlinefilter('L1LSC.txt','RM',0,2,3,4,'plot');
%
% 3) return an analog matlab sys object
%    plot the digital response
%      coef=onlinefilter('L1LSC.txt','RM',0,2,3,4,'plot','analogSYS');
%
% 4) return analog 2nd order sections and gain (compatible with matlab sos)
%    also return the filter name
%    plot the digital response
%      [sos,gain,name]=onlinefilter('L1LSC.txt','RM',0,2,3,4,'plot','analogSOS');
%

fsample = 16384; % this sample frequency is used everywhere
ret = 1;
fm = [varargin{:}];

% *** read the filter file **************************************
fid = fopen(file);
firstflag = 1;
mlen = length(module);
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  if strncmp(tline,module,mlen)
    arr = strread(tline,'%s','delimiter',' ');
    rfm = str2double(arr(2));
    if ismember(rfm,fm)
      if firstflag
        name = arr(7);
        gain = str2double(arr(8));
        coef = str2double([arr(9) arr(10) arr(11) arr(12)]);
	firstflag = 0;
      else
        name = strcat(name,'/',arr(7));
        gain = gain*str2double(arr(8));
        coef = [coef str2double([arr(9) arr(10) arr(11) arr(12)])];
      end
      nsos = str2double(arr(4));
      if nsos > 1
        for ksos=1:nsos-1
	   tline = fgetl(fid);
	   arr = strread(tline,'%s','delimiter',' ');
	   coef = [coef str2double([arr(1) arr(2) arr(3) arr(4)])];
	end;
      end
    end;
  end
end
fclose(fid);
olcoef = [gain coef];
% ***************************************************************
	
% *** make a bode plot ******************************************
if ismember('plot',fm)
  fptool(olcoef,fsample);
end
% ***************************************************************

% *** compute the analog filter *********************************
if ismember('analogSYS',fm)
     g = olcoef;
     dim = length(g);
     n2b = (dim-1)/4;
     gain = g(1);
     tottf = gain;
     for i=1:n2b,
       ad = [1, g(2+(i-1)*4), g(3+(i-1)*4)];
       bd = [1,g(4+(i-1)*4),g(5+(i-1)*4)];
       [b,a] = invbilinear(bd,ad,fsample);
       tottf = tottf*tf(b,a);
     end
     ret = tottf;
elseif ismember('analogSOS',fm)
     g = olcoef;
     dim = length(g);
     n2b = (dim-1)/4;
     gain = g(1);
     sosname = name;
     name = gain;
     anacoef = [];
     for i = 1:n2b,
       ad = [1, g(2+(i-1)*4), g(3+(i-1)*4)];
       bd = [1, g(4+(i-1)*4), g(5+(i-1)*4)];
       [b,a] = invbilinear(bd,ad,fsample);
       anacoef = [anacoef; b(1) b(2) b(3) a(1) a(2) a(3)];
     end
     ret = anacoef;
else
  ret = olcoef;
end
% ***************************************************************


       
