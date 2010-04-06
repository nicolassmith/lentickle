

chtx1(:,:)=chtx(:,1,:);
chtx2(:,:)=chtx(:,2,:);
chtx3(:,:)=chtx(:,3,:);
chtx4(:,:)=chtx(:,4,:);
chtx5(:,:)=chtx(:,5,:);
chtx6(:,:)=chtx(:,6,:);

chtxq1(:,:)=chtxq(:,1,:);
chtxq2(:,:)=chtxq(:,2,:);
chtxq3(:,:)=chtxq(:,3,:);
chtxq4(:,:)=chtxq(:,4,:);
chtxq5(:,:)=chtxq(:,5,:);
chtxq6(:,:)=chtxq(:,6,:);

clear label

label(1,:)='B2q1-tx';
label(2,:)='B2q2-tx';
label(3,:)='B5q1-tx';
label(4,:)='B5q2-tx';
label(5,:)='B7q1-tx';
label(6,:)='B7q2-tx';
label(7,:)='B8q1-tx';
label(8,:)='B8q2-tx';

clear filename

filename(1,:)='B2q1-tx';
filename(2,:)='B2q2-tx';
filename(3,:)='B5q1-tx';
filename(4,:)='B5q2-tx';
filename(5,:)='B7q1-tx';
filename(6,:)='B7q2-tx';
filename(7,:)='B8q1-tx';
filename(8,:)='B8q2-tx';



for i=1:8,
            [value,index]=Mmax(chtx(:,1,i));
            fitx1(i,:)=linspace(min(evolv(:,i)),max(evolv(:,i)),400);
                    xout(i,1,:)=lsqcurvefit(@mysine,[value,evolv(index,i)+90], evolv(:,i), chtx(:,1,i));
		    fity1(i,:)=mysine(xout(i,1,:),fitx1(i,:));
            
            [value,index]=Mmax(chtx(:,2,i));
            fitx2(i,:)=linspace(min(evolv(:,i)),max(evolv(:,i)),400);
                    xout(i,2,:)=lsqcurvefit(@mysine, [value,evolv(index,i)+90], evolv(:,i), chtx(:,2,i));
		    fity2(i,:)=mysine(xout(i,2,:),fitx2(i,:));
             
            [value,index]=Mmax(chtx(:,3,i));
                    fitx3(i,:)=linspace(min(evolv(:,i)),max(evolv(:,i)),400);
                    xout(i,3,:)=lsqcurvefit(@mysine, [value,evolv(index,i)+90], evolv(:,i), chtx(:,3,i));
		    fity3(i,:)=mysine(xout(i,3,:),fitx3(i,:));
              
            [value,index]=Mmax(chtx(:,4,i));
                    fitx4(i,:)=linspace(min(evolv(:,i)),max(evolv(:,i)),400);
                    xout(i,4,:)=lsqcurvefit(@mysine, [value,evolv(index,i)+90], evolv(:,i), chtx(:,4,i));
		    fity4(i,:)=mysine(xout(i,4,:),fitx4(i,:));
                    
            [value,index]=Mmax(chtx(:,5,i));
            fitx5(i,:)=linspace(min(evolv(:,i)),max(evolv(:,i)),400);
                    xout(i,5,:)=lsqcurvefit(@mysine, [value,evolv(index,i)+90], evolv(:,i), chtx(:,5,i));
		    fity5(i,:)=mysine(xout(i,5,:),fitx5(i,:));
                    
            [value,index]=Mmax(chtx(:,6,i));
            fitx6(i,:)=linspace(min(evolv(:,i)),max(evolv(:,i)),400);
                    xout(i,6,:)=lsqcurvefit(@mysine, [value,evolv(index,i)+90], evolv(:,i), chtx(:,6,i));
		    fity6(i,:)=mysine(xout(i,6,:),fitx6(i,:));
        
  

figure(i)

    semilogy(evolv(:,i),chtx1(:,i),'bo',evolv(:,i),chtx3(:,i),'ro',evolv(:,i),chtx4(:,i),'co',evolv(:,i),chtx5(:,i),'mo',evolv(:,i),chtx6(:,i),'ko',fitx1(i,:),fity1(i,:),'b-',fitx3(i,:),fity3(i,:),'r-',fitx4(i,:),fity4(i,:),'c-',fitx5(i,:),fity5(i,:),'m-',fitx6(i,:),fity6(i,:),'k-');
    
grid on
set(get(gcf,'CurrentAxes'),'FontSize',10)

legend('PR','NI','NE','WI','WE',sprintf('amp: %3.2g, phs:%3.0f',xout(i,1,:)),sprintf('amp: %3.2g, phs: %3.0f',xout(i,3,:)),sprintf('amp: %3.2g, phs:%3.0f',xout(i,4,:)),sprintf('amp: %3.2g, phs: %3.0f',xout(i,5,:)),sprintf('amp: %3.2g, phs: %3.0f',xout(i,6,:)),0),;
set(get(gcf,'CurrentAxes'),'FontSize',12)
set(get(gcf,'CurrentAxes'),'XMinorTick','on','XMinorGrid','off')
set(get(gcf,'CurrentAxes'),'YMinorTick','on','YMinorGrid','off')
set(gca,'XTick',min(evolv(:,i)):15:max(evolv(:,i)))
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperPosition',[2.5 14 18 12])
xlabel('demodulation phase [deg]');
ylabel([label(i,:),'  Matrix coefficient [a.u.]']);
eval(['print -depsc2 ',filename(i,:)]);
end
