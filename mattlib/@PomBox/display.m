% display a Pomona Box
%
% display(pb)

function display(pb)

  Nn = pb.N;				% number of nodes
  Nc = length(pb.c);			% number of components
  Na = length(pb.a);			% number of amplifiers

  if( Na > 1 )
    str ='Pomona Box with %d nodes, %d components, and %d amplifiers.';
    disp(sprintf(str, Nn, Nc, Na));
  elseif( Na == 1 )
    str = 'Pomona Box with %d nodes, %d components, and 1 amplifier.';
    disp(sprintf(str, Nn, Nc));
  else
    str = 'Pomona Box with %d nodes and %d passive components.';
    disp(sprintf(str, Nn, Nc));
  end
  
  disp('Passive Components:')
  for n = 1:Nc
    c = pb.c(n);
    str = sprintf(' %s: ', pb.c(n).name);
    if( c.R > 0 )
      str = [str sprintf('R = %g Ohm, ', c.R)];
    end
    if( c.C > 0 )
      str = [str sprintf('C = %g pF, ', c.C)];
    end
    if( c.L > 0 )
      str = [str sprintf('L = %g uH, ', c.L)];
    end
    str = [str sprintf('connects %s to %s.', pb.nStrs{c.n}, pb.nStrs{c.m})];
    disp(str);
  end

  if( Na > 0 )
    disp('Active Components:')
    str = ' %s: gain = %g injects at %s.';
    for n = 1:Na
      a = pb.a(n);
      disp(sprintf(str, pb.c(a.nc).name, a.gain, pb.nStrs{a.nj}));
    end
  end
