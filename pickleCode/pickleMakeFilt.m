function mFilt = pickleMakeFilt(f, defFilt)

Ndof = size(defFilt, 2);

if isa(defFilt, 'double')
  % check to make sure this response vector is the right size
  if size(defFilt, 1) ~= length(f) || size(defFilt, 2) ~= Ndof
    error('Filter response must Nfreq x Ndof.')
  end
  mFilt = defFilt;
elseif isa(defFilt, 'struct')
  % hope that this is an Evans filter struct
  mFilt = zeros(length(f), Ndof);
  
  for k = 1 : Ndof
    mFilt(:,k) = sresp(defFilt(1, k), f);
  end
else
  % not sure what this is
  error('Don''t know what to do with a %s.', class(defFilt))
end
