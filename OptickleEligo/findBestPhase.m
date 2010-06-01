function deg=findBestPhase(pI,pQ)

% if both pI and pQ are real it returns ~ 180/pi*angle(pI + i pQ)
% but it also finds the best phase if they are complex


step=1e-5;
ph=(0:step:(1-step))*pi;

y=abs( -sin(ph)*pI + cos(ph)*pQ );

m=min(y);
inds=find(y==m);
ind=inds(1);
mph=ph(ind);

mx=cos(mph)*pI + sin(mph)*pQ;

if(real(mx)<0)
  mph=mph-pi;
end

%deg=[180/pi*mph,180/pi*angle(real(pI)+i*real(pQ))];
deg=180/pi*mph;
