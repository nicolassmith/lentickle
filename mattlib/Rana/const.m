function constants = const

% CONST Outputs physical constants.
%  
%   CONSTANTS
%   Speed of Light
%      c    =  2.99792458e8   m/s
%           =            e10  cm/s
%   Plank's Constant
%      h    =  6.6261e-34 J*s
%           =        e-27 erg*s
%      hbar = h/2pi
%           =  1.0546e-34 J*s
%           =        e-27 erg*s
%   Gravitational Constant
%      G    =  6.6726e-11 m^3/kg/s
%           =        e-8  cm^3/g/s
%   Boltzmann Constant
%      k    =  1.3807e-23 J/K
%           =        e-16 erg/K
%   Stefan-Boltzmann Constant
%      s    =  5.6705e-8  W/m^2/K^4
%           =        e-5  erg/s/cm^2/K^4
%   Electron Charge
%      e    =  1.6022e-19 C
%           =  4.8032e-10 esu
%   Atomic Mass Unit
%      u    =  1.6605e-27 kg
%           =        e-24 g
%   Avagodro's Number
%      N    =  6.0221e23  1/mol
%
%   MASSES
%   electron
%      me   =  9.1094e-31 kg
%   proton
%      mp   =  1.6726e-27 kg
%   neutron
%      mn   =  1.6749e-27 kg
%   sun
%      msun =  1.989e30 kg


% Speed of Light
constants.c = 299792458;

% Plank's Constant
constants.h = 6.6261e-34;
constants.hbar = constants.h / 2 / pi;

% Gravitational Constant
constants.G = 6.6726e-11;

% Boltzmann Constant
constants.kB = 1.3807e-23;

% Stefan-Boltzmann Constant
constants.sb = 5.6705e-8;

% Electron Charge
constants.ec = 1.6022e-19;

% Atomic Mass Unit
constants.amu = 1.6605e-27;

% Avagodro's Number
constants.N = 6.0221e23;

% electron
constants.me = 9.1094e-31;

% proton
constants.mp = 1.6726e-27;

% neutron
constants.mn = 1.6749e-27;

% sun
constants.m_solar = 1.989e30;

% room temperature
constants.T_room = 273 + 25;
