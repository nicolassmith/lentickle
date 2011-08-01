% Add a passive component.
%   Adds a passive component to the PB which connects node n
%   to node m.  All passive components have the form
%
%  o-|-L-R-|-o
%    |--C--|
%
%   R is in Ohms
%   C is in pico-Farad
%   L is in micro-Henry
%
% pb = addComp(pb, name, n, m, R, [C, L])
%
% Example:
% % construct a Pomona Box model
% pb = PomBox('Vin', '1', '2', '3', '4', 'Vout', 'Ground');
%
% % then connect 'Vin' to node '2' with a 10 Ohm resistor
% pb = addComp(pb, 'Rd', 'Vin', '2', 10);
%
% % which is the same as
% pb = addComp(pb, 'Rd', 1, 3, 10);
%
% % since the first node in the call to PomBox is 'Vin' and the
% % third node is called '2'.  I recommend using the first,
% % string based, form of addComp.

function pb = addComp(pb, name, n, m, R, varargin)

  % interpret varargin
  switch nargin
   case 5
    C = 0;
    L = 0;
   case 6
    C = varargin{1};
    L = 0;
   case 7
    C = varargin{1};
    L = varargin{2};
   otherwise
    error('Too many input arguments.')
  end

  % check arguments for validity
  nameList = {pb.c.name};
  if ismember(name, nameList)
    error(sprintf('Already have a component named %s.', name));
  end

  % check for string names
  n = findNode(pb, n);
  m = findNode(pb, m);

  % store values, for use in solve
  c.name = name;
  c.n = n + pb.offset;
  c.m = m + pb.offset;
  c.R = R;
  c.C = C;
  c.L = L;

  pb.c(end + 1) = c;
