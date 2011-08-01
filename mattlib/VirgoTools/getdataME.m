% [dat, t] = getdataME(file, t0, dt, chan, [fSamp]);
%
% This function gets data from a frame file.
%
% ARGUMENTS
%   file  : frame file (GWF or FFL), or cell array of file names to try
%   t0    : GPS starting time
%   dt    : data duration, in seconds
%   chan  : channel name, or cell array of names
%   fSamp : desired sampling frequency (optional)
%
% RETURNS
%  dat : data vector
%  t   : time vector (optional)
% 
% The defalut FFL files are added to the file list, so an empty
% file argument will usually work.
%
% If fSamp is not specified, the sample rate of the first channel is
% used for all channels.
%
% The time vector returned starts from t0 modulo 1000.
%
% Example:
% % Get Pr_B8_DC, downsampled to 1kHz, and plot the result.
% [dB8, tB8] = getdataME([], 795398359, 20, 'Pr_B8_DC', 1000);
% plot(tB8, dB8)
%
% % Get more channels, at the rate of Pr_B8_DC (10kHz).
% chanB8 = {'Pr_B8_DC' 'Pr_B8_d1_DC' 'Pr_B8_d1_ACp' 'Pr_B8_d1_ACq'};
% [dB8, tB8] = getdataME([], 795398355, 10, chanB8);
% plot(tB8, dB8)
%
% **** derived from Mmgetdata.m by M. Mantovani ****
% Created: Thu Mar 17 17:43:44 CET 2005

function [dat, t] = getdataME(file, t0, dt, chan, varargin)

  % prevent warning messages while loading
  warning('off', 'frgetvect:info');

  % Fixed parameters
  frameRate = 1.0;                          % frames per second...always 1

  % if file is not a cell, make it one
  if ~iscell(file)
    if isstr(file)
      if strcmp(file, 'trend')
        file = {'/virgoData/ffl/trend.ffl'};
      else
        file = {file};
      end
    elseif isempty(file)
      file = {};
    else
      error(['Invalid chan argument.  Must be string ' ...
             'or cell array of strings.'])
    end
  end

  % add default FFL files
  fileList = {file{:}, ...
              '/virgoData/ffl/raw.ffl', ...    % main FFL file
              '/virgoData/ffl/raw_bak.ffl'};   % backup FFL file
  % if chan is not a cell, make it one
  if isstr(chan)
    chan = {chan};
  elseif ~iscell(chan)
    error('Invalid chan argument.  Must be string or cell array of strings.')
  end
  Nchan = length(chan);

  if Nchan == 0
    dat = [];
    t = [];
    return
  end

  % compute fSamp
  if ~isempty(varargin)
    fSamp = varargin{1};
  else
    fSamp = [];
  end

  % get first data and prepare fSamp
  t_start = floor(t0 - 0.1);
  nframes = frameRate * ceil(t0 + dt - t_start + 0.1);

  for n = 1:length(fileList)
    if ~isstr(fileList{n})
      error('Invalid file name.');
    elseif ~isstr(chan{1})
      error('Invalid channel name #1.');
    end
    dat1 = frgetvect(fileList{n}, chan{1}, t_start, nframes);
    if ~isempty(dat1)
      file = fileList{n};
      break
    end
  end
  if isempty(dat1)
    error(['Unable to get data for ' chan{1}])
  end
  
  fChan = size(dat1, 1) * frameRate / nframes;
  if isempty(fSamp)
    fSamp = fChan;
  end

  % first and last sample to include in output
  n0 = floor((t0 - t_start) * fSamp) + 1;
  n1 = floor((t0 + dt - t_start) * fSamp);
  dat = zeros(n1 - n0 + 1, Nchan);

  if fChan == fSamp
    dat(:, 1) = dat1(n0:n1);
  else
    dat2 = resample(dat1, fSamp, fChan);
    dat(:, 1) = dat2(n0:n1);
  end

  % get data more and resample
  for n = 2:Nchan
    if ~isstr(chan{n})
      error('Invalid channel name #%d.', n);
    end
    dat1 = frgetvect(file, chan{n}, t_start, nframes);
    fChan = size(dat1, 1) * frameRate / nframes;
    if fChan == fSamp
      dat(:, n) = dat1(n0:n1);
    else
      dat2 = resample(dat1, fSamp, fChan);
      dat(:, n) = dat2(n0:n1);
    end
  end 

  % set time vector
  if nargout == 2
  % t = mod(t_start, 1000) + (n0:n1)' / fSamp;
    t = t_start + (n0:n1)' / fSamp;
  end
