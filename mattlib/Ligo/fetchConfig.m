% Download configuration files.
%   The directory used for the dowload is 'Data/<ifoName>_<tGPS>'.
%   This directory must exist before running fetchConfig.
%
% Example:
% fetchConfig('H1', 'conlog02557.log', 753413153);
%   This will fectch files to 'Data/H1_753413153'.
%
% Function Form:
% [pLog, pFilt] = fetchConfig(ifoName, flog, tGPS)

function [pLog, pFilt] = fetchConfig(ifoName, flog, tGPS)

  % determine link to website
  if( strcmp(ifoName, 'H1') )
    lfilt = 'blue.ligo-wa.caltech.edu/hanford1/cvs/lho/chans/H1';
    llog  = 'blue.ligo-wa.caltech.edu/hanford1/cvs/lho/conlog/data/';
  elseif( strcmp(ifoName, 'H2') )
    lfilt = 'blue.ligo-wa.caltech.edu/hanford1/cvs/lho/chans/H2';
    llog  = 'blue.ligo-wa.caltech.edu/hanford1/cvs/lho/conlog/data/';
  else
    lfilt = 'london.ligo-la.caltech.edu/cds/llo/chans/L1';
    llog  = 'london.ligo-la.caltech.edu/cds/llo/conlog/data/';
  end

  % get directory contents
  dest = ['Data/' ifoName '_' int2str(tGPS)];
  fileList = dir(dest);
  if( isempty(fileList) )
    errfmt('Destination directory "%s" does not exist in "%s".', dest, pwd);
  end

  % get filter files
  nfilt = {'LSC'; 'ASC'; 'SUS_ETMX'; 'SUS_ETMY';
           'SUS_ITMX'; 'SUS_ITMY'; 'SUS_RM'; 'SUS_BS';
           'SUS_MC1'; 'SUS_MC2'; 'SUS_MC3'; 'SUS_MMT1';
           'SUS_MMT2'; 'SUS_MMT3'};
  ffilt = strcat(nfilt, '.txt');
  dfilt = strcat([dest '/'], ffilt);
  sfilt = strcat(lfilt, ffilt);

  if( any(strcmp({fileList.name}, 'LSC.txt')) )
    fprintf(1, 'Destination "%s" already contains filter files.\n', dest);
    fprintf(1, '  Skipping download.\n');
  else
    for n = 1:length(ffilt)
      getfile(dfilt{n}, sfilt{n});	% download filter files
    end
  end

  % get conlog file
  dlog = [dest '/' flog];
  slog = [llog flog];

  if( any(strcmp({fileList.name}, flog)) )
    fprintf(1, 'Destination "%s" already contains conlog file.\n', dest);
    fprintf(1, '  Skipping download.\n');
  else
    getfile(dlog, slog); 		% download conlog
  end

  % load filter files
  fprintf(1, 'Loading filter files...\n');
  pFilt.tGPS = tGPS;
  nfilt = strrep(nfilt, '_', '.');	% make names have depth
  for n = 1:length(ffilt)
    eval(['pFilt.' nfilt{n} ' = readFilterFile(dfilt{n});'])
  end

  % load conlog file
  fprintf(1, 'Loading conlog...\n');
  pLog = loadParams(dlog, ifoName, tGPS);

  % save to matlab file
  fsav = [dest '/conf.mat'];
  fprintf(1, 'Saving structs to %s ...\n', fsav);
  save(fsav, 'ifoName', 'pLog', 'pFilt');

  % display state
  fprintf(1, '\n== %s State at GPS time %0.f ==\n', ifoName, tGPS);
  dispState(pLog.IFO.SV);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getfile
function getfile(dest, link)
  wget = 'wget -q -O ';

  fprintf(1, 'Fetching %s ...\n', dest);
  [stat, str] = system([wget dest ' http://' link]);
  if( stat ~= 0 )
    error(sprintf('Unable to get "%s".', link));
  end
