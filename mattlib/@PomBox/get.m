% general get (For knowledgeable use only.)

function val = get(pb, str)

  switch str
    case 'N'; val = pb.N;
    case 'c'; val = pb.c;
    case 'a'; val = pb.a;
    otherwise; error(sprintf('PomBox: Unknown field %s.', str));
  end
