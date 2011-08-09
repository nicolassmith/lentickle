% Return the Foton ZPK string for this filter

function str = getFoton(mf)

  cr = char(10);  % \n
  
  str = 'zpk([';
  if( ~isempty(mf.z) )
    str = [str strFz(-mf.z(1))];
  end
  for n = 2:length(mf.z)
    if( mod(n, 4) == 1 )
      str = [str ';' cr strFz(-mf.z(n))];
    else
      str = [str ';' strFz(-mf.z(n))];
    end
  end

  str = [str '],' cr '['];
  if( ~isempty(mf.p) )
    str = [str strFz(-mf.p(1))];
  end
  for n = 2:length(mf.p)
    if( mod(n, 4) == 1 )
      str = [str ';' cr strFz(-mf.p(n))];
    else
      str = [str ';' strFz(-mf.p(n))];
    end
  end

  str = [str '], ' num2str(mf.k) ', "f")'];
  
return

%%%%%%%%%%%%%%%%%%%%%%%%%% convert a single number
function str = strFz(z)

  str = num2str(real(z));
  if( imag(z) == 0 )
    return
  end

  if( imag(z) < 0 )
    str = [str '-i*'];
    z = conj(z);
  else
    str = [str '+i*'];
  end

  str = [str num2str(imag(z))];
