% convert number of bytes to string (with K, M or T)

function str = bytestr(nBytes)

  if( nBytes < 2^13 )
    str = int2str(nBytes);
  elseif( nBytes < 2^23 )
    str = [int2str(nBytes / 2^10) 'K'];
  elseif( nBytes < 2^33 )
    str = [int2str(nBytes / 2^20) 'M'];
  else
    str = [int2str(nBytes / 2^30) 'T'];
  end
