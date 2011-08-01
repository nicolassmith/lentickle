% Solve the circuit for a given fixed voltage input and ground.
%
% nIn may be a string or numeric node identifier (default 'Vin')
% nGnd may be a string or numeric node identifier (default 'Ground')
%
% Return values:
%  h - transfer function from input voltage to node voltage
%  j - transfer function from input voltage to input current
%
% [h, j] = solve(pb, f, nIn, nGnd);
%
% Example:
% pb = PomBox('Vin', '1', '2', '3', '4', 'Vout', 'Ground');
%
% % ... some calls to addComp, then solve ...
% [h, j] = solve(pb, f);
%
% % is the same as
% [h, j] = solve(pb, f, 'Vin', 'Ground');
%
% % it is often useful to follow this with a call to findNode
% nOut = findNode(pb, 'Vout');			% find output node index
% hInOut = h(:, nOut);				% input to output TF


function [h, j] = solve(pb, f, nIn, nGnd)

  % check for string values of nIn and nGnd
  if nargin < 3
    nIn = 'Vin';
  end
  
  if nargin < 4
    nGnd = 'Ground';
  end
  
  nIn = findNode(pb, nIn);
  nGnd = findNode(pb, nGnd);
  
  % initialize
  s = 2 * i * pi * f;			% complex rad / s
  Nf = length(s);			% number of frequencies
  Nn = pb.N;				% number of nodes
  Nc = length(pb.c);			% number of components
  Na = length(pb.a);			% number of amplifiers
  miv = zeros(Nc, Nn, Nf);		% node voltage to component currents
  mji = zeros(Nn, Nc);			% component to node currents

  % add passive components
  for n = 1:Nc
    % compute y = 1 / impedance
    R = pb.c(n).R;			% resistance in Ohm
    C = pb.c(n).C * 1e-12;		% capacitance in pico-Farad
    L = pb.c(n).L * 1e-6;		% inductance in micro-Henry

    y = s * C;				% capacitor
    if( L ~= 0 | R ~= 0 )		% if present...
      y = y + 1./(R + s * L);		%  add resistor and inductor
    end

    % update matrices
    ncIn = pb.c(n).n;
    ncOut = pb.c(n).m;

    miv(n, ncIn, :) = y;		% current is input node voltage ...
    miv(n, ncOut, :) = -y;		%  minus output node voltage
    mji(ncIn, n) = 1;			% current leaving input node
    mji(ncOut, n) = -1;			% current entering output node
  end

  % add amplifers
  for n = 1:Na
    naComp = pb.a(n).nc;
    naOut = pb.a(n).nj;
    mji(naOut, naComp) = mji(naOut, naComp) + pb.a(n).gain;
  end

  % remove ground nodes
  nng = setdiff(1:Nn, nGnd);		% nodes that are not ground

  miv = miv(:, nng, :);			% reindex voltage matrix
  mji = mji(nng, :);			% reindex current matrix

  nIn = find(nIn == nng);		% reindex input node
  if( isempty(nIn) )
    error('The input node cannot be a ground node.')
  end

  % compute transfer functions
  h = zeros(Nf, Nn);
  j = zeros(Nf, 1);
  for nf = 1:Nf
    mvj = inv(mji * miv(:, :, nf));	% node currents to voltages
    j(nf) = 1 / mvj(nIn, nIn);		% input node current
    h(nf, nng) = mvj(:, nIn).' * j(nf);
  end
