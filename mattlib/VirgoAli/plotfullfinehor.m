both=1;  % 0 only the p signal is considered both=1 also the q signal


chty1(:,:)=chty(:,1,:);
chty2(:,:)=chty(:,2,:);
chty3(:,:)=chty(:,3,:);
chty4(:,:)=chty(:,4,:);
chty5(:,:)=chty(:,5,:);
chty6(:,:)=chty(:,6,:);

chtyq1(:,:)=chtyq(:,1,:);
chtyq2(:,:)=chtyq(:,2,:);
chtyq3(:,:)=chtyq(:,3,:);
chtyq4(:,:)=chtyq(:,4,:);
chtyq5(:,:)=chtyq(:,5,:);
chtyq6(:,:)=chtyq(:,6,:);

clear label

label(1,:)='B2q1-ty';
label(2,:)='B2q2-ty';
label(3,:)='B5q1-ty';
label(4,:)='B5q2-ty';
label(5,:)='B7q1-ty';
label(6,:)='B7q2-ty';
label(7,:)='B8q1-ty';
label(8,:)='B8q2-ty';

clear filename

filename(1,:)='B2q1-ty';
filename(2,:)='B2q2-ty';
filename(3,:)='B5q1-ty';
filename(4,:)='B5q2-ty';
filename(5,:)='B7q1-ty';
filename(6,:)='B7q2-ty';
filename(7,:)='B8q1-ty';
filename(8,:)='B8q2-ty';



for i=1:8,
            [value,index]=Mmax(chty(:,1,i));
		    fitx1(i,:)=linspace(min(evolh(:,i)),max(evolh(:,i)),400);
            xout(i,1,:)=lsqcurvefit(@mysine, [value,evolh(index,i)+90], evolh(:,i), chty(:,1,i));
		    fity1(i,:)=mysine(xout(i,1,:),fitx1(i,:));
             
            [value,index]=Mmax(chty(:,2,i));
            fitx2(i,:)=linspace(min(evolh(:,i)),max(evolh(:,i)),400);
                    xout(i,2,:)=lsqcurvefit(@mysine,  [value,evolh(index,i)+90], evolh(:,i), chty(:,2,i));
		    fity2(i,:)=mysine(xout(i,2,:),fitx2(i,:));
              
            [value,index]=Mmax(chty(:,3,i));
                    fitx3(i,:)=linspace(min(evolh(:,i)),max(evolh(:,i)),400);
                    xout(i,3,:)=lsqcurvefit(@mysine,  [value,evolh(index,i)+90], evolh(:,i), chty(:,3,i));
		    fity3(i,:)=mysine(xout(i,3,:),fitx3(i,:));
             
            [value,index]=Mmax(chty(:,4,i));
                    fitx4(i,:)=linspace(min(evolh(:,i)),max(evolh(:,i)),400);
                    xout(i,4,:)=lsqcurvefit(@mysine, [value,evolh(index,i)+90] , evolh(:,i), chty(:,4,i));
		    fity4(i,:)=mysine(xout(i,4,:),fitx4(i,:));
              
            [value,index]=Mmax(chty(:,5,i));
                    fitx5(i,:)=linspace(min(evolh(:,i)),max(evolh(:,i)),400);
                    xout(i,5,:)=lsqcurvefit(@mysine,  [value,evolh(index,i)+90], evolh(:,i), chty(:,5,i));
		    fity5(i,:)=mysine(xout(i,5,:),fitx5(i,:));
             
            [value,index]=Mmax(chty(:,6,i));
                    fitx6(i,:)=linspace(min(evolh(:,i)),max(evolh(:,i)),400);
                    xout(i,6,:)=lsqcurvefit(@mysine, [value,evolh(index,i)+90], evolh(:,i), chty(:,6,i));
		    fity6(i,:)=mysine(xout(i,6,:),fitx6(i,:));
        
  

figure(i)
if (both==1 & max(evolh)>=180)
    
    semilogy(evolh(:,i),chty1(:,i),'bo',evolh(:,i),chty3(:,i),'ro',evolh(:,i),chty4(:,i),'co',evolh(:,i),chty5(:,i),'mo',evolh(:,i),chty6(:,i),'ko',fitx1(i,:),fity1(i,:),'b-',fitx3(i,:),fity3(i,:),'r-',fitx4(i,:),fity4(i,:),'c-',fitx5(i,:),fity5(i,:),'m-',fitx6(i,:),fity6(i,:),'k-',evolh(:,i),chtyq1(:,i),'b*',evolh(:,i),chtyq3(:,i),'r*',evolh(:,i),chtyq4(:,i),'c*',evolh(:,i),chtyq5(:,i),'m*',evolh(:,i),chtyq6(:,i),'k*');
else
    semilogy(evolh(:,i),chty1(:,i),'bo',evolh(:,i),chty3(:,i),'ro',evolh(:,i),chty4(:,i),'co',evolh(:,i),chty5(:,i),'mo',evolh(:,i),chty6(:,i),'ko',fitx1(i,:),fity1(i,:),'b-',fitx3(i,:),fity3(i,:),'r-',fitx4(i,:),fity4(i,:),'c-',fitx5(i,:),fity5(i,:),'m-',fitx6(i,:),fity6(i,:),'k-');
end
grid on
set(get(gcf,'CurrentAxes'),'FontSize',10)

legend('PR','NI','NE','WI','WE',sprintf('amp: %3.2g, phs:%3.0f',xout(i,1,:)),sprintf('amp: %3.2g, phs: %3.0f',xout(i,3,:)),sprintf('amp: %3.2g, phs:%3.0f',xout(i,4,:)),sprintf('amp: %3.2g, phs: %3.0f',xout(i,5,:)),sprintf('amp: %3.2g, phs: %3.0f',xout(i,6,:)),0),;
set(get(gcf,'CurrentAxes'),'FontSize',12)
set(get(gcf,'CurrentAxes'),'XMinorTick','on','XMinorGrid','off')
set(get(gcf,'CurrentAxes'),'YMinorTick','on','YMinorGrid','off')
set(gca,'XTick',min(evolh(:,i)):15:max(evolh(:,i)))
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperPosition',[2.5 14 18 12])
xlabel('demodulation phase [deg]');
ylabel([label(i,:),'  Matrix coefficient [a.u.]']);
eval(['print -depsc2 ',filename(i,:)]);

end
