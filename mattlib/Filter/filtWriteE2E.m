% filtWriteE2E(fb, inputNames, outputNames, sep, fileName)
% write a filter bank to file in E2E FUNC_X format
% "sep" is the name separator
%
% (derived from writeFilterBank)

function filtWriteE2E(fb, inputNames, outputNames, sep, fileName)

  N = length(outputNames);
  M = length(inputNames);
  prfx = 'df_';
  
  % open file
  fid = fopen(fileName, 'w');
  if( fid == -1 )
    warning(['Cannot open output file ' fileName]);
    return
  end

  % write filters declarations
  for n = 1:N
    for m = 1:M
      filterName = [prfx inputNames{m} sep outputNames{n}];
      s = ['e2e_dfKernal ' filterName ';'];
      fprintf(fid, [s, '\n']);
    end
  end

  % write filters to settings
  fprintf(fid, '\n');
  for n = 1:N
    for m = 1:M
      filterName = [prfx inputNames{m} sep outputNames{n}];
      s = filtStrE2E(fb(n,m), filterName);
      fprintf(fid, [s, '\n']);
    end
  end

  % write noise sources
  fprintf(fid, '\n');
  for n = 1:N
    s = [inputNames{n} ' = white_noise(noiseAmp);'];
    fprintf(fid, [s, '\n']);
  end

  % write filter matrix
  fprintf(fid, '\n');
  for n = 1:N
    s = [outputNames{n} ' =\n'];
    for m = 1:M
      filterName = [prfx inputNames{m} sep outputNames{n}];
      s = [s '  ' filterName '.filterApply(' inputNames{m} ') +\n'];
    end
    s = [s(1:end-4) ';\n\n'];
    fprintf(fid, s);
  end
