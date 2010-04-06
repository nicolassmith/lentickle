function pickle = pickleEligo(opt)
% Define all the matrices for noise budget 
% (a kind of looptickle for angles)
% The names of matrices are defined as inputOutput (fromTo).
% Current definition of DOF = {'CE+CI', 'CE-CI', 'DE+DI', 'DE-DY', 'PR', 'BS', 'IBtx'};
% The matrices defined here are:

% probeSens - from optickle probes to the sensors used
% sensDof   - from sensors to dof, it is the inverse of the sensing matrix in fileSensNEW
% ctrlFilt  - control filters used for each dof
% dofMirr   - from dof to mirrors
% mirrFilt - additional filters to take into account for differences between the mirrors
% pendFilt - pendulum TF for each mirror (from penultimum mass actuator to mirror motion);
% mirrDrive - map from mirrors to Optickle drive indeces

% get the serial numbers of probes
% Current sensors used 
nC1 = getProbeNum(opt, 'REFL_B I2');
nC2 = getProbeNum(opt, 'POX_A I1');
nD1 = getProbeNum(opt, 'AS_A Q1'); 
nD2 = getProbeNum(opt, 'POX_A Q1');
nPRM = getProbeNum(opt, 'REFL_A I2');

% get the serial numbers of optics
% just these for now... others are BS, PM and AM
pp.mirrNames = {'EX', 'EY', 'IX', 'IY', 'PR'};

pp.Nmirr = numel(pp.mirrNames);
pp.vMirr = zeros(1, pp.Nmirr);
pp.driveMirr = sparse(pp.Nmirr, opt.Ndrive);
for n=1:pp.Nmirr
  pp.vMirr(n) = getDriveIndex(opt, pp.mirrNames{n});
  pp.driveMirr(n, pp.vMirr(n)) = 1;
end

% Only 5 dof and 5 mirr (left out DOFs BS, IBtx, IBdx)
pp.dofNames = {'CommUnst', 'CommStable', 'DiffUnst', 'DiffStable', 'PR'};
pp.Ndof = numel(pp.dofNames);

% index of each DOF, by name
for n = 1:pp.Ndof
  pp.(pp.dofNames{n}) = n;
end

% drive matrix
r = 0.866;
pp.dofMirr =       [1      r     1     r     0     
                    1      r    -1    -r     0     
                    r     -1     r    -1     0    
                    r     -1    -r     1     0    
                    0      0     0     0     1  ];


%           C1           D1            C2            D2 
%   IX    0.53081      0.38489       0.60012       0.4572
%   IY    0.37325     -0.52741       0.45276     -0.59791
%   EX   0.62154      0.44548      -0.52623     -0.39964
%   EY   0.43883     -0.61256      -0.39735      0.52319
% normalization by 0.53, pay attention to the order of the mirrors!                
                          
pp.mirrDrive = pp.driveMirr';
pp.dofDrive  = pp.mirrDrive * pp.dofMirr;
pp.mirrDof   = inv(pp.dofMirr);
pp.driveDof  = pp.mirrDof * pp.driveMirr ;

% Control Loop input ports and input matrix
pp.vSens = [ nC1, nC2, nD1, nD2, nPRM];

pp.probeName = getProbeName(opt, pp.vSens);
for n = 1 : pp.Ndof
pp.nameDC(n) = regexprep(pp.probeName(n), ' (\w*)', ' DC');
pp.nsigDC(n) = getProbeNum(opt, pp.nameDC{n});
end

pp.Nsens = length(pp.vSens);
pp.probeSens = sparse(pp.Nsens, opt.Nprobe);
for n=1:pp.Nsens
  pp.probeSens(n, pp.vSens(n)) = 1;
end

% Now I have only 5 dof 
 
% Full inversion
% pp.dofSens = [    988.6       299.86       31.313      -46.692      -384.51
%                   983.53      -1169.8       88.916    0.0027652      -1145.2
%                  -1655       2073.2       -16078      -4905.4       1887.8
%                   49.305      -70.983       151.68      -208.89      -69.352
%                  -288.61         1053       49.283      -48.227       1460.2 ];
 
             pp.dofSens = [    988.6       0        0          0       -384.51
                               983.53      -1169.8      0          0       -1145.2
                               0               0      -16078      0    0
                               0              0        151.68     -208.89       0
                               0             1053      0             0       1460.2 ];
             
% standard
%pp.gainSens = [0.83795       0.4584      0.99961      0.32514      0.67839];
 
pp.gainSens = [0.83795       0.4584      0.99961      0.32514      0.67839];

%Test
% pp.dofSens = [    988.6       299.86          0          0      -384.51
%                   983.53      -1169.8         0          0      -1145.2
%                     0            0      -16078      -4905.4       0
%                     0            0       151.68      -208.89     0
%                     0             0           0         0      1460.2 ];
%              
%  pp.gainSens = [ 0.91972      0.83361       0.8203      0.52122      0.50878];           
 
% pp.dofSens = [    988.6       299.86          0          0      -384.51
%                   983.53      -1169.8         0          0      -1145.2
%                     0            0      -16078      -4905.4      0
%                     0            0       151.68      -208.89     0
%                     0             0           0         0      1460.2 ];



pp.sensDof_temp = inv(pp.dofSens); 


% pp.gainSens = [ 0.91972      0.83361       0.8203      0.52122      0.51434];
pp.gainSens = [ 0.7      0.4      0.8      0.52122      0.51434]; 

for n = 1 : pp.Ndof
  pp.sensDof(n,:) = pp.gainSens(n) .* pp.sensDof_temp(n,:);
end
                 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify the control loop filters (to be tuned)
pp.gains = [ 1,  1,  1,  1,  1];
pp.freqs = [10, 10, 10, 10, 10];

%pp.filtC1 = filtZPG([filtRes(1.5, 0.7)],[0;filtRes(0, 0.7);filtRes(50, 2)], pp.gains(1), pp.freqs(1));  

pp.filtRes1 = filtZPG([filtRes(1.4, 0.8)],[filtRes(1, 10)], 1, 10);
pp.filtRes10 = filtZPG([filtRes(1.6, 0.8)],[filtRes(1.354, 10)], 1, 10);
pp.filtRes2 = filtZPG([filtRes(2.269, 1)],[filtRes(2.269, 5)], 1, 10);

pp.filtRes1PR = filtZPG([filtRes(1.617, 1)],[filtRes(1.617, 20)], 1, 10);
pp.filtRes2PR = filtZPG([filtRes(2.5, 1)],[filtRes(2.5, 10)], 1, 10);

pp.boostL = filtZPG([1.5], [0], 1, 10);
pp.boost = filtZPG([3], [0], 1, 10);

% Original
% pp.filtC1 = filtZPG([filtRes(1.5, 1)],[0;filtRes(0, 0.7); filtRes(50, 2)], pp.gains(1), pp.freqs(1));  
% pp.filtC2 = filtZPG([filtRes(1.5, 1)],[0;filtRes(0, 0.7);filtRes(50, 2)], pp.gains(2), pp.freqs(2));  
% pp.filtD1 = filtZPG([filtRes(3.0, 1)],[0;filtRes(0, 0.7);filtRes(90, 1)], pp.gains(3), pp.freqs(3));  
% pp.filtD2 = filtZPG([filtRes(0.8, 1)],[0;filtRes(0, 0.7);filtRes(40, 2)], pp.gains(4), pp.freqs(4)); 
% pp.filtPR = filtZPG([filtRes(1.5, 1)],[0;filtRes(0, 0.7);filtRes(70, 2)],pp.gains(5), pp.freqs(5)); 

pp.filtC1 = filtZPG([filtRes(0.8, 2)],[0;filtRes(0, 0.7); filtRes(50, 2)], pp.gains(1), pp.freqs(1));  
pp.filtC2 = filtZPG([filtRes(0.5, 2)],[0;filtRes(0, 0.7);filtRes(40, 2)], pp.gains(2), pp.freqs(2));  
pp.filtD1 = filtZPG([filtRes(1, 1)],[0;filtRes(0, 0.7);filtRes(60, 1)], pp.gains(3), pp.freqs(3));  
pp.filtD2 = filtZPG([filtRes(0.8, 2)],[0;filtRes(0, 0.7);filtRes(40, 2)], pp.gains(4), pp.freqs(4)); 
pp.filtPR = filtZPG([filtRes(0.5, 1)],[0;filtRes(0, 0.7);filtRes(60, 2)],pp.gains(5), pp.freqs(5)); 

zfq = [ 36, 10; 72, 3];
pfq = [ 28, 3; 24, 0.7];

zfq_H = [ 35, 30; 50, 10; 80, 10];
pfq_H = [ 32, 3; 30, 3; 27, 0.8];

zfq_I = [ 31.5, 30; 45, 10; 72, 10];
pfq_I = [ 28.8, 3; 27, 3; 24.3, 0.8];

zfq_L = [ 29.75, 30; 42.5, 10; 68, 10];
pfq_L = [ 27.2, 3; 25.5, 3; 22.95, 0.8];


zfq_PR = [ 45, 10; 80, 10];
pfq_PR = [ 35, 5; 30, 1];

% zfq_AS = [ 54, 10; 96, 10];
% pfq_AS = [ 42, 3; 36, 1];

% zfq_AS = [ 50, 30; 72, 10; 115.2, 10];
% pfq_AS = [ 46, 3; 43.2, 3; 38.8, 0.8];

% zfq_AS = [ 58, 30; 80, 10; 125, 10];
% pfq_AS = [ 54, 3; 50, 3; 40, 0.8];

 zfq_AS = [ 60, 10; 116, 3];
 pfq_AS = [ 42, 3; 36, 1];
 
test_Hcut = filtZPG([filtRes(zfq_H(:, 1), zfq_H(:, 2))], [ filtRes(pfq_H(:,1), pfq_H(:,2))], 1, 10);
test_Lcut = filtZPG([filtRes(zfq_I(:, 1), zfq_I(:, 2))], [ filtRes(pfq_I(:,1), pfq_I(:,2))], 1, 10);
test_PRcut = filtZPG([filtRes(zfq_PR(:, 1), zfq_PR(:, 2))], [ filtRes(pfq_PR(:,1), pfq_PR(:,2))], 1, 10);
test_AScut = filtZPG([filtRes(zfq_AS(:, 1), zfq_AS(:, 2))], [ filtRes(pfq_AS(:,1), pfq_AS(:,2))], 1, 10);

test_LLcut = filtZPG([filtRes(zfq_L(:, 1), zfq_L(:, 2))], [ filtRes(pfq_L(:,1), pfq_L(:,2))], 1, 10);

test_cut = filtZPG([filtRes(zfq(:, 1), zfq(:, 2))], [ filtRes(pfq(:,1), pfq(:,2))], 1, 10);
pp.filtResTEST = filtZPG([filtRes(0.5, 0.8),filtRes(1, 0.8) ],[filtRes(0.7, 20), filtRes(1.2, 20)], 1, 10);
pp.filtResTEST1 = filtZPG([filtRes(0.5, 0.8),filtRes(1, 0.8) ],[filtRes(0.7, 25), filtRes(1.2, 25)], 1, 10);

pp.ctrlC1 = filtProd(pp.filtC1, pp.filtResTEST, test_Hcut);
pp.ctrlC2 = filtProd(pp.filtC2, pp.filtResTEST,test_Hcut); 
pp.ctrlD1 = filtProd(pp.filtD1, pp.filtResTEST,  test_AScut);
pp.ctrlD2 = filtProd(pp.filtD2, pp.filtResTEST, test_Lcut); 
pp.ctrlPR = filtProd(pp.filtPR, pp.filtResTEST,test_PRcut); 



pp.ctrlFilt = [pp.ctrlC1, pp.ctrlC2, pp.ctrlD1, pp.ctrlD2, pp.ctrlPR];

% Specify the pendulum TF (from PM actuator to mirror pitch motion, to be tuned)

pp.pend = filtZPG([], filtRes(0.6, 50.0025), 1, 0);
 
pp.pendFilt = [pp.pend, pp.pend, pp.pend, pp.pend, pp.pend];

% Specify the mirror specific filter

%test_cut = filtZPG([filtRes(35, 50); filtRes(50, 10);filtRes(68, 10)], [ filtRes(34,10); filtRes(30, 3);filtRes(25, 1)], 1,10);


pp.mirrFiltPR_temp = filtZPG([filtRes(0.6, 1)],[] , 1, 0);
pp.mirrFiltTM_temp = filtZPG(filtRes(0.6, 1), [] , 1, 0);
pp.mirrFiltPR = filtProd(pp.mirrFiltPR_temp);
pp.mirrFiltTM = filtProd(pp.mirrFiltTM_temp);

pp.mirrFilt = [pp.mirrFiltTM, pp.mirrFiltTM, pp.mirrFiltTM, pp.mirrFiltTM, pp.mirrFiltPR];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify the signals for spot monitoring
pp.vSpotSig = zeros(1, pp.Nmirr);
pp.vSpotField = zeros(1, pp.Nmirr);
for n=1:pp.Nmirr
  pp.vSpotSig(n) = getProbeNum(opt, [pp.mirrNames{n} '_DC']);
  pp.vSpotField(n) = getFieldIn(opt, pp.mirrNames{n}, 'fr');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put opt and all the parameters in pickle
pickle.param = pp;
pickle.opt = opt; 
