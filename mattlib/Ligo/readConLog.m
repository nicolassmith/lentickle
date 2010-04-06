% read values from a control log file
%  chanList - channel list
%
% The return values are:
% sval - a cell array of channel values (string)
% fval - an array of flag values (double)
% tval - an array of last-change times (double)
%
% If the channel value is a number, use str2double to convert.
% For more general conversions, use sscanf.
%
% [sval, fval, tval] = readConLog(fileName, chanList, tGPS)

function [sval, fval, tval] = readConLog(fileName, chanList, tGPS)

  % open file
  fid = fopen(fileName);
  if( fid == -1 )
    errfmt('Unable to open file "%s"', fileName);
  end

  % init data struct
  NM = size(chanList);
  sval = cell(NM);
  tval = repmat(NaN, NM);
  fval = repmat(NaN, NM);

  % make string hashes
  chanHash = zeros(prod(NM), 1);
  for j = 1:prod(NM)
    chanHash(j) = mystrhash(chanList{j});
  end

  % loop through file
  str = fgetl(fid);
  lineNum = 0;
  tHB = 0;				% heart-beat time
  nHB = 0;				% number of heart-beats so far

  while( ~isempty(str) & isstr(str) & tHB < tGPS )
    % let the user know we are working
    lineNum = lineNum + 1;		% for error messages
    if( mod(lineNum, 3000) == 0 & nHB > 0 )
      fprintf(1, '.');
    end

    % deal with comments and heart-beat
    if( str(1) == '#' )
      if( length(str) > 4 & str(2) == '@' )
        tHB = sscanf(str(4:end), '%f', 1);
        if( nHB == 0 )
          if( tHB > tGPS )
            beep
            fprintf(1, '%s starts at %0.f, after %0.f.\n', fileName, tHB,tGPS);
          else
            fprintf(1, '%s starts at %0.f.\nReading', fileName, tHB);
          end
          nHB = nHB + 1;
        end
      end
      str = fgetl(fid);
      continue				% CONTINUE: not data line
    end

    % parse text line
    n = find(str == ',');
    if( length(n) < 3 )
      errfmt('Something is wrong with this file.  See line %d.', lineNum);
    end
    tstr = str(1:n(1) - 1);
    flag = str(n(1) + 1:n(2) - 1);
    chan = str(n(2) + 1:n(3) - 1);
    val  = str(n(3) + 1:end);

    % remove IFO header from channel name
    n = find(chan == ':');
    if( length(n) ~= 1 )
      errfmt('Something is wrong with this file.  See line %d.', lineNum);
    end
    head = chan(1:n - 1);
    tail = chan(n + 1:end);

    % inlined "mystrhash" below, from strhash.m
    r = 2^32;
    s = uint32(chan);
    hashVal = double(s(4));
    for j = 5:length(s)
      m = mod(hashVal, 16);
      hashVal = hashVal * 2^m;
      hashVal = mod(hashVal, r) + fix(hashVal / r);
      hashVal = double(bitxor(s(j), uint32(hashVal)));
    end

    % find channel in name list
    nv = (hashVal == chanHash);
    n = find(nv);
    if( ~isempty(n) )
      n = n(find(strcmp(chan, chanList(n))));
      sval(n) = {val};
      tval(n) = sscanf(tstr, '%f', 1);
      fval(n) = sscanf(flag, '%f', 1);

      % tstr sometimes suffers from bad clocks, so check it agains tHB
      dt = tval(n) - tHB;
      if( dt > 2 | (dt < 2 & nHB > 1) )
        fprintf(1, '!');
        tval(n) = tHB;			% so use tHB instead
      end
    end

    % read next line
    str = fgetl(fid);
  end

  fprintf(1, 'Done\n');
  if( tHB < tGPS )
    beep
    fprintf(1, '%s ends at %0.f, before %0.f.\n', fileName, tHB, tGPS);
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mystrhash
%   copied from strhash.m
% This is here so that the inline version, used
% in the main loop, will be consistent with the
% hasing done at the top of the file, which uses
% this function.

function hashVal = mystrhash(chan)

  r = 2^32;
  s = uint32(chan);
  hashVal = double(s(4));
  for n = 5:length(s)
    m = mod(hashVal, 16);
    hashVal = hashVal * 2^m;
    hashVal = mod(hashVal, r) + fix(hashVal / r);
    hashVal = double(bitxor(s(n), uint32(hashVal)));
  end
