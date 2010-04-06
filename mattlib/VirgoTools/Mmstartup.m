% 24/01/05
%
% function [phat,cohethre,cohesearchrange,channel,chanmir,fsamplingQ,
%            fsamplingM,line,calfact]=Mmstartup(TxTy,lines)
%
% This function set the input parameters which will be used in the matrixmeasurementv03.m function
% 
% Input:
% - TxTy horizontal or vertical direction
%  [for (TxTy)=0 the lines are on Tx], [for (TxTy)=1 the lines are on Ty]
% - lines ( 'LF' for low frequency lines,'MLF' for medium-low frequency lines, 'MF' for medium frequency lines, 'HF' for high frequency  lines)
%
% Output:
% - phat (threshold above which the phase is considered pi)
% - cohethre (threshold on the coherence function)
% - cohesearchrange (range on the coherence analysis)
% - channel (vector where the channel names are  loaded)
% - fsamplingQ (quadrants channels sampling frequency)
% - fsamplingM (mirrors channels sampling frequency)
% - line (vector with the mirrors lines frequencies)
% - calfacta (calibration factor for the amplitude to obtain the tx/y displacement as input vector of the matrix)
% - calfactp (calibration factor for the phase to obtain the tx/y displacement as input vector of the matrix)
% M.Mantovani

function [phat,cohethre,cohesearchrange,channel,chanmir,fsamplingQ,fsamplingM,line,calfacta,calfactp]=Mmstartup(TxTy,lines)
    
    % threshold above which the phase is considered pi
    phat=pi/2.; 
    % threshold on the coherence function
    cohethre=0.7; 
    % range on the coherence analysis
    cohesearchrange=3;

    line=zeros(1,6);  
     
% List of channels extracted for the horizontal matrix
% B2 quadrants
channelh(1,:) = 'Pr_B2_q1_ACph';
channelh(2,:) = 'Pr_B2_q1_ACqh';
channelh(3,:) = 'Pr_B2_q2_ACph';
channelh(4,:) = 'Pr_B2_q2_ACqh';
% B5 quadrants
channelh(5,:) = 'Pr_B5_q1_ACph';
channelh(6,:) = 'Pr_B5_q1_ACqh';
channelh(7,:) = 'Pr_B5_q2_ACph';
channelh(8,:) = 'Pr_B5_q2_ACqh';
% B7 quadrants
channelh(9,:)  = 'Pr_B7_q1_ACph';
channelh(10,:) = 'Pr_B7_q1_ACqh';
channelh(11,:) = 'Pr_B7_q2_ACph';
channelh(12,:) = 'Pr_B7_q2_ACqh';
% B8 quadrants
channelh(13,:) = 'Pr_B8_q1_ACph';
channelh(14,:) = 'Pr_B8_q1_ACqh';
channelh(15,:) = 'Pr_B8_q2_ACph';
channelh(16,:) = 'Pr_B8_q2_ACqh';    
% List of channels extracted for the vertical matrix
% B2 quadrants
channelv(1,:) = 'Pr_B2_q1_ACpv';
channelv(2,:) = 'Pr_B2_q1_ACqv';
channelv(3,:) = 'Pr_B2_q2_ACpv';
channelv(4,:) = 'Pr_B2_q2_ACqv';
% B5 quadrants
channelv(5,:) = 'Pr_B5_q1_ACpv';
channelv(6,:) = 'Pr_B5_q1_ACqv';
channelv(7,:) = 'Pr_B5_q2_ACpv';
channelv(8,:) = 'Pr_B5_q2_ACqv';
% B7 quadrants
channelv(9,:)  = 'Pr_B7_q1_ACpv';
channelv(10,:) = 'Pr_B7_q1_ACqv';
channelv(11,:) = 'Pr_B7_q2_ACpv';
channelv(12,:) = 'Pr_B7_q2_ACqv';
% B8 quadrants
channelv(13,:) = 'Pr_B8_q1_ACpv';
channelv(14,:) = 'Pr_B8_q1_ACqv';
channelv(15,:) = 'Pr_B8_q2_ACpv';
channelv(16,:) = 'Pr_B8_q2_ACqv';
%mirror vertical degree of freedom         
% mirror horizontal degree of freedom         
    switch (lines)
    case {'LF'}
       % mirror horizontal degree of freedom 
        chanmirh(1,:)='Gx_PR_ty';
        chanmirh(2,:)='Gx_BS_ty';
        chanmirh(3,:)='Gx_NI_ty';
        chanmirh(4,:)='Gx_NE_ty';
        chanmirh(5,:)='Gx_WI_ty';
        chanmirh(6,:)='Gx_WE_ty';
       % mirror vertical degree of freedom         
        chanmirv(1,:)='Gx_PR_tx';
        chanmirv(2,:)='Gx_BS_tx';
        chanmirv(3,:)='Gx_NI_tx';
        chanmirv(4,:)='Gx_NE_tx';
        chanmirv(5,:)='Gx_WI_tx';
        chanmirv(6,:)='Gx_WE_tx';
       
        %Sampling rate of quadrants 500Hz
        fsamplingQ=500;
        %Sampling rate of mirror motion 500Hz
        fsamplingM=500;
 
       % mirror LF lines
        % PRty line 23Hz
        lineset(1,1)=23;
        % BSty line 1.5Hz 
        lineset(1,2)=30.5;
        % NIty line 25.5Hz 
        lineset(1,3)=1.6;
        % NEty line 27Hz 
        lineset(1,4)=2.2;
        % WIty line 29.5Hz 
        lineset(1,5)=1.5;
        % WEty line 31Hz:  
        lineset(1,6)=2.2;
        % PRtx line 33Hz
        lineset(1,7)=33;
        % BStx line 1.5Hz 
        lineset(1,8)=30.5;
        % NItx line 37Hz 
        lineset(1,9)=5.4;
        % NEtx line 39Hz 
        lineset(1,10)=4.9;
        % WItx line 41Hz 
        lineset(1,11)=5.2;
        % WEtx line 43Hz:  
        lineset(1,12)=4.9;
       
        m=zeros(1,12);
        q=zeros(1,12);
        mp=zeros(1,12);
        qp=zeros(1,12);
    case {'HF'}
       % mirror horizontal degree of freedom
        chanmirh(1,:)='Sc_PR_tyCmir';
        chanmirh(2,:)='Sc_BS_tyCmir';
        chanmirh(3,:)='Sc_NI_tyCmir';
        chanmirh(4,:)='Sc_NE_tyCmir';
        chanmirh(5,:)='Sc_WI_tyCmir';
        chanmirh(6,:)='Sc_WE_tyCmir';
       % mirror vertical degree of freedom  
        chanmirv(1,:)='Sc_PR_txCmir';
        chanmirv(2,:)='Sc_BS_txCmir';
        chanmirv(3,:)='Sc_NI_txCmir';
        chanmirv(4,:)='Sc_NE_txCmir';
        chanmirv(5,:)='Sc_WI_txCmir';
        chanmirv(6,:)='Sc_WE_txCmir';
   
        %Sampling rate of quadrants 500Hz
        fsamplingQ=500;
        %Sampling rate of mirror motion 10kHz
        fsamplingM=10000;
        
       % mirror HF lines 
        % PRty line 23Hz    
        lineset(1,1)=23;
        % BSty line 1.5Hz 
        lineset(1,2)=1.5;
        % NIty line 25.5Hz 
        lineset(1,3)=25.5;
        % NEty line 27Hz 
        lineset(1,4)=27;
        % WIty line 29.5Hz 
        lineset(1,5)=29.5;
        % WEty line 31Hz:  
        lineset(1,6)=31;
        % PRtx line 33Hz
        lineset(1,7)=33;
        % BStx line 1.5Hz 
        lineset(1,8)=1.5;
        % NItx line 37Hz 
        lineset(1,9)=37;
        % NEtx line 39Hz 
        lineset(1,10)=39;
        % WItx line 41Hz 
        lineset(1,11)=41;
        % WEtx line 43Hz:  
        lineset(1,12)=43;
        
        % Calibration parameters
        % horizontal parameters
        % Amplitude calibration
        m(1,1)=1.9204;
        m(1,2)=2.1440;
        m(1,3)=2.1060;
        m(1,4)=2.2667;
        m(1,5)= 2.1886;
        m(1,6)=2.2264;
        q(1,1)=-4.0605;
        q(1,2)=-6.5382;
        q(1,3)=-4.9955;
        q(1,4)=-5.4081;
        q(1,5)=-4.9999;
        q(1,6)=-5.3727; 
        % Phase calibration
        mp(1,1)=0.020998;
        mp(1,2)=0.021487;
        mp(1,3)=0.017926;
        mp(1,4)=0.021614;
        mp(1,5)=0.020151;
        mp(1,6)=0.021360;
        qp(1,1)=0.029693;
        qp(1,2)=0.065641;
        qp(1,3)=0.064189;
        qp(1,4)=0.120542;
        qp(1,5)=0.104711;
        qp(1,6)=-3.079916; 
        % vertical parameters
        % Amplitude calibration
        m(1,7)= 2.1866;
        m(1,8)= 2.1560;
        m(1,9)= 2.1710;
        m(1,10)=2.1460;
        m(1,11)=1.9992;
        m(1,12)=2.2770; 
        q(1,7)=-5.0073;
        q(1,8)=-6.6415;
        q(1,9)=-5.1604;
        q(1,10)=-5.0429;
        q(1,11)=-4.0730;
        q(1,12)=-5.5432;
        % Phase calibration
        mp(1,7)=0.019616; 
        mp(1,8)=0.022460;
        mp(1,9)=0.018380; 
        mp(1,10)=0.013836;
        mp(1,11)=0.026344;
        mp(1,12)=0.020607;
        qp(1,7)=0.059028;
        qp(1,8)=0.012891;
        qp(1,9)=0.044688;
        qp(1,10)=0.295164;
        qp(1,11)=-0.100039;
        qp(1,12)=-0.023298; 
     case {'MLF'}
       % mirror horizontal degree of freedom
        chanmirh(1,:)='Sc_PR_tyCmir';
        chanmirh(2,:)='Sc_BS_tyCmir';
        chanmirh(3,:)='Sc_NI_tyCmir';
        chanmirh(4,:)='Sc_NE_tyCmir';
        chanmirh(5,:)='Sc_WI_tyCmir';
        chanmirh(6,:)='Sc_WE_tyCmir';
       % mirror vertical degree of freedom  
        chanmirv(1,:)='Sc_PR_txCmir';
        chanmirv(2,:)='Sc_BS_txCmir';
        chanmirv(3,:)='Sc_NI_txCmir';
        chanmirv(4,:)='Sc_NE_txCmir';
        chanmirv(5,:)='Sc_WI_txCmir';
        chanmirv(6,:)='Sc_WE_txCmir';
   
        %Sampling rate of quadrants 500Hz
        fsamplingQ=500;
        %Sampling rate of mirror motion 10kHz
        fsamplingM=10000;
        
       % mirror MF lines 
        % PRty line 22Hz    
        lineset(1,1)=27;
        % BSty line 1.5Hz 
        lineset(1,2)=1.5;
        % NIty line 26Hz 
        lineset(1,3)=25.5;
        % NEty line 30Hz 
        lineset(1,4)=23;
        % WIty line 34Hz 
        lineset(1,5)=20;
        % WEty line 38Hz:  
        lineset(1,6)=18;
        % PRtx line 24Hz
        lineset(1,7)=27;
        % BStx line 1.5Hz 
        lineset(1,8)=1.5;
        % NItx line 28Hz 
        lineset(1,9)=25.5;
        % NEtx line 32Hz 
        lineset(1,10)=23;
        % WItx line 36Hz 
        lineset(1,11)=20;
        % WEtx line 40Hz:  
        lineset(1,12)=18;
        
        % Calibration parameters
        % horizontal parameters
        % Amplitude calibration
        m(1,1)=1.9204;
        m(1,2)=2.1440;
        m(1,3)=2.1060;
        m(1,4)=2.2667;
        m(1,5)= 2.1886;
        m(1,6)=2.2264;
        q(1,1)=-4.0605;
        q(1,2)=-6.5382;
        q(1,3)=-4.9955;
        q(1,4)=-5.4081;
        q(1,5)=-4.9999;
        q(1,6)=-5.3727; 
        % Phase calibration
        mp(1,1)=0.020998;
        mp(1,2)=0.021487;
        mp(1,3)=0.017926;
        mp(1,4)=0.021614;
        mp(1,5)=0.020151;
        mp(1,6)=0.021360;
        qp(1,1)=0.029693;
        qp(1,2)=0.065641;
        qp(1,3)=0.064189;
        qp(1,4)=0.120542;
        qp(1,5)=0.104711;
        qp(1,6)=-3.079916; 
        % vertical parameters
        % Amplitude calibration
        m(1,7)= 2.1866;
        m(1,8)= 2.1560;
        m(1,9)= 2.1710;
        m(1,10)=2.1460;
        m(1,11)=1.9992;
        m(1,12)=2.2770; 
        q(1,7)=-5.0073;
        q(1,8)=-6.6415;
        q(1,9)=-5.1604;
        q(1,10)=-5.0429;
        q(1,11)=-4.0730;
        q(1,12)=-5.5432;
        % Phase calibration
        mp(1,7)=0.019616; 
        mp(1,8)=0.022460;
        mp(1,9)=0.018380; 
        mp(1,10)=0.013836;
        mp(1,11)=0.026344;
        mp(1,12)=0.020607;
        qp(1,7)=0.059028;
        qp(1,8)=0.012891;
        qp(1,9)=0.044688;
        qp(1,10)=0.295164;
        qp(1,11)=-0.100039;
        qp(1,12)=-0.023298; 
        
      case {'MF'}
       % mirror horizontal degree of freedom
        chanmirh(1,:)='Sc_PR_tyCmir';
        chanmirh(2,:)='Sc_BS_tyCmir';
        chanmirh(3,:)='Sc_NI_tyCmir';
        chanmirh(4,:)='Sc_NE_tyCmir';
        chanmirh(5,:)='Sc_WI_tyCmir';
        chanmirh(6,:)='Sc_WE_tyCmir';
       % mirror vertical degree of freedom  
        chanmirv(1,:)='Sc_PR_txCmir';
        chanmirv(2,:)='Sc_BS_txCmir';
        chanmirv(3,:)='Sc_NI_txCmir';
        chanmirv(4,:)='Sc_NE_txCmir';
        chanmirv(5,:)='Sc_WI_txCmir';
        chanmirv(6,:)='Sc_WE_txCmir';
   
        %Sampling rate of quadrants 500Hz
        fsamplingQ=500;
        %Sampling rate of mirror motion 10kHz
        fsamplingM=10000;
        
       % mirror MF lines 
        % PRty line 22Hz    
        lineset(1,1)=22;
        % BSty line 1.5Hz 
        lineset(1,2)=1.5;
        % NIty line 26Hz 
        lineset(1,3)=26;
        % NEty line 30Hz 
        lineset(1,4)=30;
        % WIty line 34Hz 
        lineset(1,5)=34;
        % WEty line 38Hz:  
        lineset(1,6)=38;
        % PRtx line 24Hz
        lineset(1,7)=24;
        % BStx line 1.5Hz 
        lineset(1,8)=1.5;
        % NItx line 28Hz 
        lineset(1,9)=28;
        % NEtx line 32Hz 
        lineset(1,10)=32;
        % WItx line 36Hz 
        lineset(1,11)=36;
        % WEtx line 40Hz:  
        lineset(1,12)=40;
        % Calibration parameters
        % horizontal parameters
        % Amplitude calibration
        m(1,1)=1.9204;
        m(1,2)=2.1440;
        m(1,3)=2.1060;
        m(1,4)=2.2667;
        m(1,5)= 2.1886;
        m(1,6)=2.2264;
        q(1,1)=-4.0605;
        q(1,2)=-6.5382;
        q(1,3)=-4.9955;
        q(1,4)=-5.4081;
        q(1,5)=-4.9999;
        q(1,6)=-5.3727; 
        % Phase calibration
        mp(1,1)=0.020998;
        mp(1,2)=0.021487;
        mp(1,3)=0.017926;
        mp(1,4)=0.021614;
        mp(1,5)=0.020151;
        mp(1,6)=0.021360;
        qp(1,1)=0.029693;
        qp(1,2)=0.065641;
        qp(1,3)=0.064189;
        qp(1,4)=0.120542;
        qp(1,5)=0.104711;
        qp(1,6)=-3.079916; 
        % vertical parameters
        % Amplitude calibration
        m(1,7)= 2.1866;
        m(1,8)= 2.1560;
        m(1,9)= 2.1710;
        m(1,10)=2.1460;
        m(1,11)=1.9992;
        m(1,12)=2.2770; 
        q(1,7)=-5.0073;
        q(1,8)=-6.6415;
        q(1,9)=-5.1604;
        q(1,10)=-5.0429;
        q(1,11)=-4.0730;
        q(1,12)=-5.5432;
        % Phase calibration
        mp(1,7)=0.019616; 
        mp(1,8)=0.022460;
        mp(1,9)=0.018380; 
        mp(1,10)=0.013836;
        mp(1,11)=0.026344;
        mp(1,12)=0.020607;
        qp(1,7)=0.059028;
        qp(1,8)=0.012891;
        qp(1,9)=0.044688;
        qp(1,10)=0.295164;
        qp(1,11)=-0.100039;
        qp(1,12)=-0.023298; 
        
    otherwise
        disp('unknown lines frequency range')
    end
    calfact=zeros(1,6);
    if (TxTy==1)
        channel=channelh;
        chanmir=chanmirh;
        for i=1:6,
            line(1,i)=lineset(1,i);
            calfacta(1,i)=(exp(-q(1,i))*(line(1,i)^(-m(1,i))))^(-1); 
            calfactp(1,i)=(line(1,i)*mp(1,i)+qp(1,i));
        end
    else 
        channel=channelv;
        chanmir=chanmirv;
        for i=1:6,
            j=i+6;
            line(1,i)=lineset(1,j);
            calfacta(1,i)=(exp(-q(1,j))*(line(1,i)^(-m(1,j))))^(-1);
            calfactp(1,i)=(line(1,i)*mp(1,j)+qp(1,j));
        end
    end   
  