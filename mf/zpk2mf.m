function mf = zpk2mf(zpk)
    % converts a matlab zpk object to a mf (matt filter) object. It is
    % assumed that the zpk uses radian/s units and the mf uses Hz.

    if numel(zpk)~=1
        error('hold on! I can only take 1x1 zpk objects.')
    end

    [z,p,k] = zpkdata(zpk);
    
    mf = struct('z', -z{1}/(2*pi), 'p', -p{1}/(2*pi), 'k', k);

end