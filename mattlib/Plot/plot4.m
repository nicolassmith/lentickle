% like plot3, but a forth variable is accounted for by changing the
% width of the line segments.  LineWidth varies from width(1)
% (w <= 0) to width(2) (w >= 1).  A w(1) less than 0.5 indicates that
% a dotted line should be used.  All three components of of the lines
% Color property also vary from color(:, 1) to color(:, 2)
%
%
% Input:
% Name                Size        Description
% data                Nx4         data to plot (x, y, z, w)
% width               2x1         width range
% color               2x3         color range
%
% Output:
% Name                Size        Description

function plot4(data, varargin)

% assign inputs
if( size(data, 2) ~= 4 )
  error('Input data must be Nx4.')
end

if( nargin > 1 )
  width = varargin{1};
else
  width = [0.499; 5]';
end

if( nargin > 1 )
  color = varargin{1};
else
  color = [0.8, 0.8, 0.8; 0, 0, 0]';
end

% prepare plot
wasHold = ishold;
if( ~wasHold )
  cla
end

% being plotting
for n = 1:(size(data, 1) - 1)
  shadedLine(data(n + [0, 1], :), width, color, 0.01);
end

% set view
if( ~wasHold )
  view(3)
end
