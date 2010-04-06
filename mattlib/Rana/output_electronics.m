function [varargout] = output_electronics(varargin)

% OUTPUT_ELECTRONICS - gives the current noise through a single actuator
%  coil, due to DAC noise, dewhitening filter noise, coil driver noise,
%  and angle bias module noise
%
%  [cdnoise,dacnoise,cdnoises] = output_electronics( f, d2a_noise , 'type');
%  
%  Inputs:  
%         f: frequency vector
%         d2a_noise: DAC output noise, in volts/rtHz
%         type: suspension type, current types are:
%               'ETM': older style ETM coil driver, obsolete
%               'ETMH1': H1's ETM coil electronics
%               'ETML0': L1's S4 ETM coil electronics
%               'ETML1': L1's post-S4 ETM electronics
%               'ITM': original ITM electronics
%               'ITML1': L1's ITM electronics
%               'ETM_Z': the Z's are post S5
%               'BS': beamsplitter electronics
%               'RM': recycling mirror electronics
%
%  Outputs:
%        cdnoise:  current noise due to post-DAC electronics
%        dacnoise: current noise due to DAC
%        cdnoises: structure containing individual terms:
%                  cdnoises.a: CD input resistor thermal noise
%                  cdnoises.b: CD op-amp voltage noise
%                  cdnoises.c: CD op-amp current noise
%                  cdnoises.d: CD feedback resistor thermal noise
%                  cdnoises.e: dewhitening board output noise
%                  cdnoises.f: coil series resistance thermal noise
%                  cdnoises.g: bias module resistor thermal noise
%                  cdnoises.h: bias module output voltage noise
%
% NOTE: variable output arguments returned as follows:
%       0: nothing returned, plot made
%       1: returns total current noise: sqrt(cdnoise.^2 + dacnoise.^2)
%       2: [cdnoise,dacnoise]
%       3: [cdnoise,dacnoise,cdnoises]
%
if nargin < 2
  penteknoise = 15e-6;                                % Volts/rtHz
  if nargin == 1
    f = varargin{1};
  elseif nargin < 1
    f = logspace(1,3,300);
  end

elseif nargin > 1
  f = varargin{1};
  penteknoise = varargin{2};
  board_num = 'A1';
  
  if nargin == 3
    board_num = varargin{3};
  end
  
elseif nargin > 3
  error('Too Many Arguments')

end

%FOTON_path = '/home/rana/FOTON/L1/';
FOTON_path = '/cvs/cds/llo/chans/';

constants = const;
kB = constants.kB;
T = constants.T_room;

w = 2*pi*f;

% Coil Driver Output Resistor
Rs = 7.2e3;                    % series resistor

% Coil Driver Input Resistor
Rin = 470 + 100;               % Coil driver input R+ DW output R

% Power amp feedback resistor
Rfeed = 7200;                              

% LT1128 Noise
LT1128_vin = 1.0e-9;   % typical is 0.9nV at 100 Hz
LT1128_iin = 2.0e-12;  % typical at 70 Hz; knee at 250 Hz

% OP27 Noise
OP27_vin = 3.0e-9;  % above 30 Hz
OP27_iin = 0.7e-12; % at 60 Hz; knee at 140 Hz

% Force/mass per Volt per Coil
v2f = (1/Rs) * 0.016;                     % 0.016 Newtons/Amp per Coli

switch upper(board_num)
 
 case 'A1'
  % Dewhitening Filter (from D000183-A1)
  tf1 = tf([1 336 1.131e5], [1 112 6893]);
  tf2 = tf([1 64.14 5.653e4], [1 58.64 3444]);
  tf3 = tf([1 614.2 8.036e5], [1 7678 1.256e8]);
  tf4 = zpk(-2*pi*[97.76 86.7], -2*pi*[5.77 1223], 1.0348/2);
  dwf = tf1 * tf2 * tf3 * tf4;

 case 'ETM'

  coef=onlinefilter([FOTON_path 'L1SUS_ETMY.txt'],'ULCOIL',8,'analogSYS');
  %coef = dewhitening_filter('R2');
  dwf = coef;
  
  Rin = 100 + 1590;
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 21600;
  Rf2 = 1e5;
  Cf = 5e-6;
  Cb = 1e-12;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = OP27_vin .* abs(1 + Zf/Rin);       % opamp input voltage noise
  
  cdnoise3 = OP27_iin .* abs(Zf);               % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));  % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);              % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  
  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 1500;
  R2 = 1500;
  
  Z1 = R1;
  
  Cn = 5e-12;
  Rn = 1e9;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';  
  
  % Bias module noise on the ETMs. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias_x = 1300;
  Rbias_y = 1300;
  
  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (20e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (20e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);
  
  
 case 'ETMH1'

  %coef=onlinefilter([FOTON_path 'H1SUS_ETMY.txt'],'ULCOIL',6,'analogSYS');
  coef = dewhitening_filter('R2');
  dwf = coef;
  
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200;
  Rf2 = 2400;
  Cf = 1.56e-6;
  Cb = 1e-9;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = LT1128_vin .* abs(1 + Zf/Rin);      % opamp input voltage noise
  
  cdnoise3 = LT1128_iin .* abs(Zf);              % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));    % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);               % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));
  
  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 3000;
  R2 = 4000;
  
  Z1 = R1;
  
  Cn = 5e-6;
  Rn = 1000;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
    
  % Bias module noise on the ETMs. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias_x = 7200;
  Rbias_y = 3000;
  
  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (20e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (20e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);
  
  
 case 'ETM_Z'

  % More PA85 filtering
  % Bias noise is 3nV + thermal noise
  % 15K bias resistors (300 V supplies)

  coef = dewhitening_filter('R2');
  dwf = coef;
  
  Rin = 100 + 470;
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200;
  Rf2 = 800;
  Cf = 4e-6;
  Cb = 1e-9;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = LT1128_vin .* abs(1 + Zf/Rin);      % opamp input voltage noise
  
  cdnoise3 = LT1128_iin .* abs(Zf);              % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));    % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);               % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  
  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 3000;
  R2 = 4000;
  
  Z1 = R1;
  
  Cn = 10e-6;
  Rn = 3000;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
    
  % Bias module noise on the ETMs. 

  
  % Bias resistors increased to 15000 Ohms
  Rbias_x = 15000;
  Rbias_y = 15000;
  
  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (3e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (3e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);
  
  
 case 'ETML0'

  %coef=onlinefilter([FOTON_path 'H1SUS_ETMY.txt'],'ULCOIL',6,'analogSYS');
  coef = dewhitening_filter('R2');
  dwf = coef;
  
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200;
  Rf2 = 2400;
  Cf = 2e-6;
  Cb = 1e-9;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = OP27_vin .* abs(1 + Zf/Rin);          % opamp input voltage noise
  
  cdnoise3 = OP27_iin .* abs(Zf);                  % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));     % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);                 % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  
  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 1500;
  R2 = 1500;
  
  Z1 = R1;
  
  Cn = 5e-6;
  Rn = 1e9;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
    
  % Bias module noise on the ETMs. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias_x = 4500;
  Rbias_y = 7500;

  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (20e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (20e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);
  
 case 'ETML1'

  %coef=onlinefilter([FOTON_path 'H1SUS_ETMY.txt'],'ULCOIL',6,'analogSYS');
  coef = dewhitening_filter('R2');
  dwf = coef;
  
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200;
  Rf2 = 2400;
  Cf = 2e-6;
  Cb = 1e-9;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = LT1128_vin .* abs(1 + Zf/Rin);       % opamp input voltage noise
  
  cdnoise3 = LT1128_iin .* abs(Zf);               % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));    % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);                % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  
  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 3000;
  R2 = 4000;
  
  Z1 = R1;
  
  Cn = 5e-6;
  Rn = 1000;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
  
  % Bias module noise on the ETMs. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias_x = 4500;
  Rbias_y = 7500;
  
  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (10e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (10e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);
  
 case 'ITM'
  
  %coef=onlinefilter([FOTON_path 'H1SUS_ITMX.txt'],'ULCOIL',6,'analogSYS');
  coef = dewhitening_filter('R2');
  dwf = coef;

  % Pole/Zero Pair in the Coil Driver
  R3A = 1e3;
  C3A = 5e-6;

  fp = 1 / (2*pi*C3A * (R3A+Rfeed));
  fz = 1 / 2 / pi /R3A / C3A;

  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200;
  Rf2 = 1000;
  Cf = 5e-6;
  Cb = 1e-9;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = LT1128_vin .* abs(1 + Zf/Rin);     % opamp input voltage noise
  
  cdnoise3 = LT1128_iin .* abs(Zf);             % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));     % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);                 % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 3000;
  R2 = 10;
  
  Z1 = R1;
  
  Cn = 1e-12;
  Rn = 1000;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
  
  % Bias module noise on the ITMs. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias_x = 7200;
  Rbias_y = 7200;
  
  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (20e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (20e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);
  
 case 'ITML1'
  
  %coef=onlinefilter([FOTON_path 'H1SUS_ITMX.txt'],'ULCOIL',6,'analogSYS');
  coef = dewhitening_filter('R2');
  dwf = coef;

  % Pole/Zero Pair in the Coil Driver
  Rin = 100 + 1590;
  Rf1 = 7200 * 3;
  Rf2 = 1000;
  Cf = 5e-6;
  Cb = 1e-9;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = OP27_vin .* abs(1 + Zf/Rin);       % opamp input voltage noise
  
  cdnoise3 = OP27_iin .* abs(Zf);               % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));   % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);               % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 7500;
  R2 = 10;
  
  Z1 = R1;
  
  Cn = 1e-12;
  Rn = 1000;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
  
  % Bias module noise on the ITMs. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias_x = 7200;
  Rbias_y = 7200;
  
  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (10e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (10e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);

 case 'ITM_Z'
  
  % 15K series resistor for ITM coil driver
  % Bias noise is 3nV + thermal noise
  % 15K bias resistors (300 V supplies)
  
  coef = dewhitening_filter('R2');
  dwf = coef;

  % Pole/Zero Pair in the Coil Driver
  Rin = 100 + 1590;
  Rf1 = 7200 * 3;
  Rf2 = 1000;
  Cf = 5e-6;
  Cb = 1e-9;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = OP27_vin .* abs(1 + Zf/Rin);       % opamp input voltage noise
  
  cdnoise3 = OP27_iin .* abs(Zf);               % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));   % Feedback resistor thermal noise
  
  cdnoise5 = (6e-9) * abs(Zf/Rin);               % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 15000;
  R2 = 10;
  
  Z1 = R1;
  
  Cn = 1e-12;
  Rn = 1000;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
  
  % Bias module noise on the ITMs. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias_x = 15000;
  Rbias_y = 15000;
  
  Bnoise1_x = sqrt(4 * kB * T / Rbias_x) * ones(length(f),1);
  Bnoise2_x = (3e-9) / Rbias_x * ones(length(f),1);
  Bnoise_x = sqrt(Bnoise1_x.^2 + Bnoise2_x.^2);

  Bnoise1_y = sqrt(4 * kB * T / Rbias_y) * ones(length(f),1);
  Bnoise2_y = (3e-9) / Rbias_y * ones(length(f),1);  
  Bnoise_y = sqrt(Bnoise1_y.^2 + Bnoise2_y.^2);

  Bnoise = sqrt(Bnoise_x.^2 + Bnoise_y.^2)/sqrt(2);
  Bnoise1 = sqrt(Bnoise1_x.^2 + Bnoise1_y.^2)/sqrt(2);
  Bnoise2 = sqrt(Bnoise2_x.^2 + Bnoise2_y.^2)/sqrt(2);

 case 'BS'
  
  coef=onlinefilter([FOTON_path 'L1SUS_BS.txt'],'ULCOIL',8,'analogSYS');
  dwf = coef;

  Rin = 1590 + 100;
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200 * 3;
  Rf2 = 100e3;
  Cf = 5e-6;
  Cb = 1e-11;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = OP27_vin .* abs(1 + Zf/Rin);          % opamp input voltage noise
  
  cdnoise3 = OP27_iin .* abs(Zf);                  % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));     % Feedback resistor thermal noise
  
  cdnoise5 = (20e-9) * abs(Zf/Rin);                 % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  % test of new BS dewhites...
  %mdwf = filtZPG([ 51; 153; filtRes([36.7; 36.8], [2; 2])], ...
  %           [5.0; 919; filtRes([11; 13.1], [1.9; 2.2])], 1, 0);
  %dewhite = abs(sresp(mdwf, f'));

  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 3000;
  R2 = 10;
  
  Z1 = R1;
  
  Cn = 1e-12;
  Rn = 100e3;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
  
  % Bias module noise on the BS. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias = 7200;
  Bnoise1 = sqrt(4 * kB * T * Rbias) / Rbias * ones(length(f),1);
  Bnoise2 = (3e-9) / Rbias * ones(length(f),1);
  
  Bnoise = sqrt(Bnoise1.^2 + Bnoise2.^2);
  
  
 case 'BS_Z'
  
  %coef=onlinefilter([FOTON_path 'L1SUS_BS.txt'],'ULCOIL',8,'analogSYS');
  %dwf = coef;
  
  % New DWF for the BS (post-S5)
  dwf1 = zpk(-2*pi*[30+30i;30-30i],-2*pi*[9+14i;9-14i],1);
  dwf2 = zpk(-2*pi*[50 120],-2*pi*[5 2000],1);
  dwf = dwf1 * dwf1 * dwf2;
  [mmaagg,phph] = bode(dwf,2*pi*0.001);
  dwf = dwf/mmaagg;
  
  Rin = 1590 + 100;
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200 * 3;
  Rf2 = 100e3;
  Cf = 5e-6;
  Cb = 1e-11;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = OP27_vin .* abs(1 + Zf/Rin);          % opamp input voltage noise
  
  cdnoise3 = OP27_iin .* abs(Zf);                  % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));     % Feedback resistor thermal noise
  
  cdnoise5 = (5e-9) * abs(Zf/Rin);                 % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 3000;
  R2 = 10;
  
  Z1 = R1;
  
  Cn = 1e-12;
  Rn = 100e3;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
  
  % Bias module noise on the BS. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias = 7200;
  Bnoise1 = sqrt(4 * kB * T * Rbias) / Rbias * ones(length(f),1);
  Bnoise2 = (3e-9) / Rbias * ones(length(f),1);
  
  Bnoise = sqrt(Bnoise1.^2 + Bnoise2.^2);
  
  
 case 'RM'
  
  coef=onlinefilter([FOTON_path 'L1SUS_RM.txt'],'ULCOIL',8,'analogSYS');
  dwf = coef;

  Rin = 1590 + 100;
  % Pole/Zero Pair in the Coil Driver
  Rf1 = 7200 * 3;
  Rf2 = 100e3;
  Cf = 5e-6;
  Cb = 1e-11;
  
  Zf = 1./(i*w*Cb + 1/Rf1 + 1./(Rf2 + 1./(i*w*Cf)));
  Zf = Zf';
  
  cdnoise1 = sqrt(abs(4*kB*T/Rin .* Zf.^2));    % input R thermal noise 
  
  cdnoise2 = OP27_vin .* abs(1 + Zf/Rin);       % opamp input voltage noise
  
  cdnoise3 = OP27_iin .* abs(Zf);               % opamp input current noise
  
  cdnoise4 = sqrt(abs(4 * kB * T * real(Zf)));   % Feedback resistor thermal noise
  
  cdnoise5 = (60e-9) * abs(Zf/Rin);              % Dewhitening board output noise

  
  dewhite = abs(mybodesys(dwf,f));

  Rc = 20;
  Lc = 3e-3;
  Zc = Rc + i*w*Lc;
  
  R1 = 3000;
  R2 = 10;
  
  Z1 = R1;
  
  Cn = 1e-12;
  Rn = 100e3;
  Zn = Rn + 1./(i*w*Cn);
  
  Z3 = R2 + Zc;
  
  Z2 = 1 ./ (1./Zn + 1./Z3);
  
  V2 = Z2 ./ (Z1 + Z2);
  
  IpV = V2 ./ Z3;
  
  
  % Impedance to ground from the top of the coil (excluding bias)
  Z2 = real(R2 + 1./(1/R1 + 1./Zn));
  
  % Current noise
  Rnoise = sqrt(abs(4 * kB * T ./ Z2))';
  
  % Bias module noise on the BS. 
  % This approximation assumes that the coil has much less impedance than
  % the output impedance of the coil driver or the bias module.
  % i.e. all the bias module current noise goes through the coil
  
  % Current Noise
  Rbias = 7200;
  Bnoise1 = sqrt(4 * kB * T * Rbias) / Rbias * ones(length(f),1);
  Bnoise2 = (20e-9) / Rbias * ones(length(f),1);
  
  Bnoise = sqrt(Bnoise1.^2 + Bnoise2.^2);
  
  
 otherwise
  error('Unknown Dewhitening Board')

end



cdnoise = abs(sqrt((cdnoise1.^2 +...
               cdnoise2.^2 +...
               cdnoise3.^2 +...
               cdnoise4.^2 +...
               cdnoise5.^2) .*...
               ((IpV').^2) +...
               Rnoise.^2 +...
               Bnoise.^2)); 

cofac = abs(IpV');
%cofac = 1;
cdnoises.a = cdnoise1 .* cofac;
cdnoises.b = cdnoise2 .* cofac;
cdnoises.c = cdnoise3 .* cofac;
cdnoises.d = cdnoise4 .* cofac;
cdnoises.e = cdnoise5 .* cofac;
cdnoises.f = Rnoise;
cdnoises.g = Bnoise1;
cdnoises.h = Bnoise2;


dacnoise = abs(penteknoise .* dewhite .* (Zf/Rin) .*IpV');


if nargout == 0
  bodemag(dwf,{2*pi*1 2*pi*10000})

elseif nargout == 1
  vvvnoise = sqrt(cdnoise.^2 + dacnoise.^2);
  varargout(1) = {vvvnoise};
  
elseif nargout == 2
  varargout(1) = {cdnoise};
  varargout(2) = {dacnoise};

elseif nargout == 3
  varargout(1) = {cdnoise};
  varargout(2) = {dacnoise};
  varargout(3) = {cdnoises};

elseif nargout > 3
  error('Too many output arguments')
  
end
    
return
