%
% writeFilterBank(fb, inputNames, outputNames, sep, fileName)
%
% write a filter bank to file in E2E FUNC format
% "sep" is the name separator

function writeFilterBank(fb, inputNames, outputNames, sep, fileName)

  N = length(outputNames);
  M = length(inputNames);

  % open file
  fid = fopen(fileName, 'a');
  if( fid == -1 )
    warning(['Cannot open output file ' fileName]);
    return
  end

  % write filters to file
  for n = 1:N
    for m = 1:M
      s = getFilterString(fb(n,m), ['df_' inputNames{m} sep outputNames{n}]);
      fprintf(fid, [s, '\n']);
    end
  end

  % write filter matrix
  for n = 1:N
    s = [outputNames{n} ' = '];
    for m = 1:M
      s = [s 'df_' inputNames{m} sep outputNames{n} '(' inputNames{m} ') + '];
    end
    s = [s(1:end-3) ';\n'];
    fprintf(fid, s);
  end
