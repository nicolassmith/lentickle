% NoiseData: subsref

function val = subsref(pb, s)

  % handle first reference
  ss = s(1);
  switch ss.type 
    case '()'
      val = pb(ss.subs{:});
    case '.'
      val = get(pb, ss.subs);
    otherwise
      error(sprintf('Dunno how to %s index a %s.', ss.type, class(pb)));
  end

  % let result deal with later references
  if( length(s) > 1 )
    val = subsref(val, s(2:end));
  end

