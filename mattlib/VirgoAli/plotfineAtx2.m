both=0;  % 0 only the p signal is considered both=1 also the q signal

dataset=zeros(4,2,length(B7q1_pv_NI));
dataset1(:,1)=abs(B7q1_pv_NI);
dataset2(:,1)=abs(B7q1_pv_NE);
dataset1(:,2)=abs(B7q2_pv_NI);
dataset2(:,2)=abs(B7q2_pv_NE);
dataset1(:,3)=abs(B8q1_pv_WI);
dataset2(:,3)=abs(B8q1_pv_WE);
dataset1(:,4)=abs(B8q2_pv_WI);
dataset2(:,4)=abs(B8q2_pv_WE);
label(1,:)='B7q1-N-tx';
label(2,:)='B7q2-N-tx';
label(3,:)='B8q1-W-tx';
label(4,:)='B8q2-W-tx';

clear filename 

filename(1,:)='q1Ntxfine';
filename(2,:)='q2Ntxfine';
filename(3,:)='q1Wtxfine';
filename(4,:)='q2Wtxfine';


ampl(1)=0.054;
ampl(2)=0.23;
ampl(3)=0.06;
ampl(4)=0.24;
ampl(5)=0.073;
ampl(6)=0.19;
ampl(7)=0.079;
ampl(8)=0.13;

for i=1:4
    i
fitx(i,:)=linspace(min(evolv(:,i+4))-15,max(evolv(:,i+4))+15,400);
xout(i,1,:)=lsqcurvefit(@mysine, [ampl(i),120], evolv(:,i+4), dataset1(:,i),[ampl(2*i-1),0],[ampl(2*i-1)+0.001,240])
fity1(i,:)=mysine(xout(i,1,:),fitx(i,:));
xout(i,2,:)=lsqcurvefit(@mysine, [ampl(i), 127], evolv(:,i+4), dataset2(:,i),[ampl(2*i),0],[ampl(2*i)+0.001,240])
fity2(i,:)=mysine(xout(i,2,:),fitx(i,:));


figure(i)

    semilogy(evolv(:,i+4),dataset1(:,i),'bo',evolv(:,i+4),dataset2(:,i),'ro',fitx(i,:),fity1(i,:),'b-',fitx(i,:),fity2(i,:),'r-');
grid on
set(get(gcf,'CurrentAxes'),'FontSize',10)

legend('In','End',sprintf('amp: %3.2g, phs:%3.0f',xout(i,1,:)),sprintf('amp: %3.2g, phs: %3.0f',xout(i,2,:)),0);
set(get(gcf,'CurrentAxes'),'FontSize',12)
set(get(gcf,'CurrentAxes'),'XMinorTick','on','XMinorGrid','off')
set(get(gcf,'CurrentAxes'),'YMinorTick','on','YMinorGrid','off')
%set(gca,'YTick',0:.05:0.25)
set(gca,'XTick',min(evolv(:,i+4)):15:max(evolv(:,i+4)))
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperPosition',[2.5 14 18 12])
xlabel('demodulation phase [deg]');
ylabel([label(i,:),'  Matrix coefficient [a.u.]']);
eval(['print -depsc2 ',filename(i,:)]);

end
