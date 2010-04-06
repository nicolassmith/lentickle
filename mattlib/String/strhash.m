% returns a hash code for a single string
%
% val = strhash(str)

function val = strhash(str)

  % magic numbers
  p = 3084996963;				% MAGIC_P = 0xb7e15163
  q = 2654435769;				% MAGIC_Q = 0x9e3779b9
  r = 2^32;					% radix

  s = uint32(str);				% convert string to uint32
  N = length(s);				% do this only once
  a = double(N);				% initialize a
  b = double(s(end));				% and b (to whatever)

  for m = 1:4					% 4 hashing rounds
    for n = 1:N					% through the string
      % right rotate a, then mix with s and p
      a = a * 2^mod(b, 32);			% shift right (b mod 32 bits)
      a = mod(a, r) + fix(a / r);		% wrap high bits
      au = bitxor(s(n), uint32(a));		% mix with s
      a = double(bitxor(uint32(p), au));	% mix with p
      p = mod(p + q, r);			% go to next magic number

      % right rotate b, then mix with s and p
      b = b * 2^mod(a, 32);
      b = mod(b, r) + fix(b / r);
      bu = bitxor(s(n), uint32(b));
      b = double(bitxor(uint32(p), bu));
      p = mod(p + q, r);
    end
  end

  % combine a and b
  val = a + b * r;
