% Add a passive component and an active amplifier.
%   Adds a passive component to the PB which connects node n
%   to node m (see addComp).  In addition to this, an amplifier
%   is added which measures current passing through this passive
%   component, amplifies it, and injects it into node nj.
%
%   name, n, m, R, C, L all apply to the passive component
%    (default is R = 10 MOhm, C = 10 pF, L = 0)
%   nj in the node where the output current goes
%   gain is the amplifier gain (default 1e12)
%
% pb = addAmp(pb, name, n, m, nj, [gain, R, C, L])

function pb = addAmp(pb, name, n, m, nj, varargin)

  % interpret varargin
  switch nargin
   case 5
    gain = 1e12;
    args = {10e6, 10};
   case 6
    gain = varargin{1};
    args = {10e6, 10};
   case {7, 8, 9}
    gain = varargin{1};
    args = varargin{2:end};
   otherwise
    error('Too many input arguments.')
  end

  % check for string names
  n = findNode(pb, n);
  m = findNode(pb, m);
  nj = findNode(pb, nj);

  % store values, for use in solve
  a.nc = length(pb.c) + 1;
  a.nj = nj + pb.offset;
  a.gain = gain;

  % add components
  pb = addComp(pb, name, n, m, args{:});
  pb.a(end + 1) = a;
