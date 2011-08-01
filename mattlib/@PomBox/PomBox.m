% Pomona Box
%   Make an empty circuit with the given list of node names.
%   Arguments must be strings, or integers which represent a
%   sequence of numerically named nodes.
%
% pb = PomBox(node names ...)
%
% see also PomBox/addComp, PomBox/addAmp and PomBox/solve for an example

function pb = PomBox(varargin)

  % set node names and node count
  pb.N = 0;
  pb.nStrs = {};
  for n = 1:length(varargin)
    if( isnumeric(varargin{n}) )
      pb.N = pb.N + 1;
      pb.nStrs{pb.N} = num2str(pb.N);
    elseif( isstr(varargin{n}) )
      pb.N = pb.N + 1;
      pb.nStrs{pb.N} = varargin{n};
    else
      error('Arguments must be strings or integers.');
    end
  end
  pb.offset = 0;
  
  % initialize component vector
  c = struct('name', [], 'n', 0, 'm', 0, 'R', 0, 'C', 0, 'L', 0);
  pb.c = c([]);
  
  % initialize amplifier vector
  a = struct('nc', 0, 'nj', 0, 'gain', 0);
  pb.a = a([]);
  
  % set class definition
  pb = class(pb, 'PomBox');
