% Reads all filters from a filter file and returns them in a
% struct with fields for each filter.  Each filter field is
% a vector of filter module sturcts which contain a name, a
% gain value, and an soscoef vector.
% (Inspired by Peter Fritschel's filter reader.)
%
% NOTE: matlab indices start at 1, so module indices will be
% one greater than their filter file index.
%
% Example:
% >> pfilt = readFilterFile('L1LSC.txt');
% >> pfilt.DARM(1)
% ans = 
%       name: '0^2:30^2'
%       gain: 2
%    soscoef: [1 -1.9907 0.9908 1 -2 1]
%
% Function Form:
% p = readFilterFile(fileName)

function p = readFilterFile(fileName)

  % open file
  fid = fopen(fileName);
  if( fid == -1 )
    errfmt('Unable to open filter file "%s".\n', fileName);
  end

  % init
  p.fileName = fileName;

  % loop through file
  str = fgetl(fid);
  while( isstr(str) )

    % parse line into cell array of strings
    if( isempty(str) )
      arg = {};
    else
      arg = strread(str,'%s','delimiter',' ');
    end

    % check line
    if( isempty(arg) )
      % empty or blank line
    elseif( strcmp(arg{1}, '#') & length(arg) > 2 )
      % comment line, may have info
      switch( arg{2} )
        case 'MODULES'
          % filter module declarations
          for n = 3:length(arg)
            if( ~isfield(p, arg{n}) )
              p.(arg{n}) = emptyFilter;
            end
          end

        case 'SAMPLING'
          % filter module sampling rate
          [p.(arg{3}).fs] = deal(str2real(arg{4}));

        case 'DESIGN'
          % filter module design string
          fname = arg{3};
          index = str2real(arg{4}) + 1;
          dstr = [arg{5:end}];
          while( dstr(end) == '\' )
            str = fgetl(fid);
            n = find(str ~= ' ');
            dstr = [dstr(1:end-1) str(n(2:end))];
          end
          p.(fname)(index).design = dstr;
      end
    elseif( length(arg) == 12 )
      % filter module data
      [fname, index, name, soscoef] = readFM(arg, fid);

      % store result in struct
      %fprintf(1, '%s - %s %d %f\n', fname, name, index, gain);
      p.(fname)(index).name = name;
      p.(fname)(index).soscoef = soscoef;
    elseif( str(1) ~= '#'  )
      warning(sprintf('Unparsed line in filter file "%s".', fileName));
      disp(sprintf('"%s"', str));
    end


    % read next line
    str = fgetl(fid);
  end

  fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% readFM
function [fname, index, name, soscoef] = readFM(arg, fid)

  % assign fields
  fname = arg{1};				% filter name
  index = str2real(arg{2}) + 1;			% module index
  name = arg{7};				% module name
  gain = str2real(arg{8});			% module gain
  coef = str2real(arg(9:12));			% coefficients

  % read more second order sections
  Nsos = str2real(arg{4});
  for n = 1:Nsos - 1
    str = fgetl(fid);
    arg = strread(str,'%s','delimiter',' ');
    coef = [coef str2real(arg(1:4))];
  end

  % rearrange SOS coefficients
  soscoef = zeros(size(coef, 2), 6);
  for n = 1:size(coef, 2)
    soscoef(n, :) = [1 coef(3:4, n)' 1 coef(1:2, n)'];
  end
  soscoef(1, :) = soscoef(1, :) .* [gain gain gain 1 1 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% str2real
function r = str2real(str)

  if( isstr(str) )
    r = sscanf(str, '%f', 1);
  elseif( iscellstr(str) )
    r = zeros(size(str));
    for n = 1:length(str)
      r(n) = sscanf(str{n}, '%f', 1);
    end
  else
    error('Arugment not a str or cellstr.');
  end
